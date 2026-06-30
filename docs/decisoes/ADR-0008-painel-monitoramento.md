# ADR-0008 — Painel de Monitoramento da gestora

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
As gestoras **monitoram** os processos (não aprovam etapa a etapa). Precisavam de
uma visão rápida do que precisa de atenção — atacando as dores do fechamento
mensal, principalmente **D1** (cliente atrasa documentos) e **D4** (atrasos /
esquecimentos).

## Decisão
Criar a aba **"📡 Monitoramento"** (só gestoras), que vira a **tela inicial** delas.
Carrega sozinha no **mês atual** e mostra:
- **Cartões:** % concluído · 🔴 atrasadas · 🟡 aguardando documento · ⏳ pendentes.
- **Por pessoa:** barra de progresso %, nº de empresas, atrasos e aguardando.
- **Empresas que precisam de atenção:** com atraso ou esperando documento.
- **Por tipo de tarefa:** quais tarefas (ex.: "Apuração ICMS") mais acumulam
  atraso/pendência no geral. *(incluído a pedido da Patrícia)*

## Consequências técnicas
- `initMonitor()` agrega o `db` (tarefas) do mês — **somente leitura** (não cria
  tarefas). Reutiliza a mesma varredura do relatório.
- Como as tarefas começam vazias, o painel mostra um **estado inicial** e ganha
  vida conforme a equipe marca as tarefas.
- (Limpeza) Removido resíduo de tarefas de teste acumulado durante o desenvolvimento.

## Impacto operacional (no escritório)
- A gestora vê em segundos quem está atrasado, o que está parado e quem espera
  documento — controle real dos processos.

## Benefício esperado
- ⏱️ **Tempo:** decisão de onde agir em segundos.
- ✅ **Qualidade:** controle operacional dos processos (o foco do período).
- 🛡️ **Risco:** nada passa batido (atrasos e pendências visíveis num lugar só).
