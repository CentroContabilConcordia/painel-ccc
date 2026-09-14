# ADR-0025 — Redução de tráfego de dados (egress) na sincronização

- **Data:** 2026-09-14
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Em 14/09/2026 o projeto no Supabase entrou em **serviços restritos (HTTP 402)** e a
equipe **inteira ficou sem conseguir logar** (o painel mostrava "Senha incorreta",
mas a senha estava certa — o Auth respondia 402). Causa, confirmada na tela de uso:
**cota de Saída/egress do plano gratuito estourada — 6,149 / 5 GB (123%)**. Todos os
outros limites estavam baixíssimos (banco 29 MB, MAU 5/50.000, tempo real <1%). Ou
seja: **não era volume de usuárias nem de dados — era repetição de download**.

Diagnóstico no código (`iniciarApp`):
1. **Busca completa a cada 20 segundos** (`setInterval` chamando `loadDB`) — enquanto
   qualquer pessoa ficava com o painel aberto, baixava o pacote inteiro de tarefas
   3×/min o dia todo.
2. **A cada mudança remota, recarregava TUDO** — `loadDB`+`loadRef`+`loadBancos`+
   `loadEmpresasCad`+`loadColaboradores`+`loadProcessos` para **todos** os usuários
   logados, a cada gravação de qualquer um. Além disso, `loadRef`/`loadBancos` são da
   tabela `empresas`, que **nem dispara** o realtime de `kv_store` (recarga inútil).

## Decisão
Otimizar a sincronização, **sem mudar nada do que a equipe vê/usa**:
- **Removida a busca de 20 em 20 segundos.** O tempo real já avisa quando alguém grava.
- **Recarregar só o que mudou:** o adaptador (`backend-supabase.js`) passou a informar
  **qual chave** de `kv_store` mudou; a camada de cima recarrega **apenas** o blob
  correspondente (`ccc_v8`→tarefas, `ccc_processos_v1`→processos, `ccc_empresas_v1`,
  `ccc_colab_v1`). Chave desconhecida ⇒ recarrega tudo (fallback seguro).
- **Debounce de 1,5s:** rajadas de gravações viram **uma única** recarga.
- **Rede de segurança leve:** ressincroniza as tarefas ao **voltar para a aba**
  (no máx. 1×/2min), no lugar do timer de 20s.
- Tirados `loadRef`/`loadBancos` do caminho do realtime (não sincronizavam nada ali).

Decisão de plano (parte da mesma resolução): **assinar o Supabase Pro** (US$ 25/mês,
250 GB de egress) para **restaurar o acesso imediatamente**, mantendo o **limite de
gasto ligado** (sem cobrança por excedente). A otimização evita a recorrência e mantém
o consumo muito abaixo da cota.

## Alternativas consideradas
- **Esperar o reset da cota (26/09):** descartada — ~12 dias com a equipe parada.
- **Só otimizar sem assinar:** não destrava o ciclo atual (cota já estourada).
- **Excluir usuárias para reduzir custo:** não resolve — o gargalo é egress, não MAU.

## Consequências técnicas
- `backend-supabase.js`: o handler de `postgres_changes` passa `payload.new.key` ao
  callback `onRemoteChange(key)`.
- `index.html`: novo `onRemoteChange` com `Set` de chaves pendentes + `setTimeout`
  (debounce 1,5s) e recarga seletiva; removido o `setInterval` de 20s; adicionado
  `visibilitychange` com trava de 2 min. Cache-bust dos scripts `?v=6`→`?v=7`.
- Verificado: sintaxe (`node --check`) dos dois arquivos; lógica de roteamento
  (rajada de 5 saves ⇒ 1 recarga; processos ⇒ só processos; chave nula ⇒ tudo);
  página carrega sem erros de console. Teste ponta-a-ponta do realtime fica para
  quando o serviço voltar.

## Impacto operacional (no escritório)
- Nada muda no uso. A sincronização continua "ao vivo" (tempo real), mas para de
  baixar dados à toa.

## Benefício esperado
- 🛡️ **Redução de erros/custo:** queda estimada de ~80–90% no egress — evita novo
  bloqueio por cota.
- ⏱️ **Tempo:** painel mais leve/responsivo (menos idas ao servidor).
- ✅ **Qualidade:** sincronização continua imediata via tempo real.

## Follow-up (possível ADR futuro)
Guardar as tarefas em **pedaços** (por mês/responsável) em vez de um único blob
`ccc_v8` — hoje cada gravação reescreve e re-trafega o pacote inteiro. Reduziria ainda
mais o egress e o tamanho das mensagens de tempo real. Requer migração de dados.
