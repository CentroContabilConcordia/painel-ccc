# ADR-0002 — Isolamento de acesso por pessoa ("gavetas por pessoa")

- **Data:** 2026-06-29
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Hoje os dados de todos ficam numa "gaveta única" compartilhada (blobs no
`kv_store`). As regras de segurança (RLS) só conseguem liberar ou bloquear a
gaveta inteira — não conseguem dizer "cada um vê só a sua parte". Para um
escritório contábil, é necessário **sigilo real** entre as carteiras de cada
colaborador.

## Decisão
Adotar o modelo **"gaveta trancada por pessoa"**:
- Cada membro tem seus dados (empresas, tarefas, fichas) guardados separadamente,
  etiquetados com o **dono**.
- Criar uma **tabela de perfis** ("quem é quem": pessoa, setor, se é gestora),
  ligada às contas de login.
- **Regra de visibilidade:**
  - **Gestoras (Patty, Diane):** veem tudo (chave-mestra).
  - **Fiscal (Cristiane, Cleonice, Julia, Gabriela):** cada uma vê **só a própria
    carteira** — isolada das demais.
  - **Contábil (Carla, Neusa, Marli):** veem o **setor contábil inteiro,
    compartilhado** entre as três (NÃO é separado por pessoa).
- A tabela `profiles` guarda o `setor`, o que permite aplicar essa regra na RLS
  (Fase 3): fiscal isola por dono; contábil libera para quem é do setor contábil.

## Alternativas consideradas
- **Esconder só na tela** — rejeitada: não é sigilo real (dá pra burlar pela API).
- **Banco totalmente relacional (normalização total)** — adiada: é a evolução
  ideal, mas é uma reforma grande; fazer quando Portal do Cliente / relatórios
  avançados exigirem.

## Consequências técnicas
- Nova tabela `profiles` + funções `is_gestora()` / `meu_member_id()`.
- Coluna de **dono** nos dados + novas políticas RLS por dono.
- App passa a carregar só os dados do dono logado (gestora carrega tudo).
- Migração: dividir as fichas atuais pela empresa/dono (tarefas estão zeradas).
- Implementação em **fases**, cada uma testada e revisada.

## Impacto operacional (no escritório)
Cada colaborador vê **só a própria carteira** (menos distração, responsabilização
clara). Gestoras mantêm visão total para coordenar. Cria a base de sigilo que o
**Portal do Cliente** vai exigir.

## Benefício esperado
- ⏱️ **Tempo:** menos ruído; cada um foca no que é seu.
- ✅ **Qualidade:** organização e responsabilidade por carteira.
- 🛡️ **Redução de erros/risco:** elimina vazamento entre carteiras → sigilo real
  (ética profissional + LGPD).
