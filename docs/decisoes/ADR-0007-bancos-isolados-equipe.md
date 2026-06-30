# ADR-0007 — Bancos isolados por empresa + equipe pode editar

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Os bancos (contas bancárias por empresa) ficavam num "blob" compartilhado no
`kv_store` (`ccc_bancos_v1`) e só a gestora podia editar. A equipe precisava
**incluir e alterar** bancos. Conta bancária é **dado sensível** — não pode ficar
visível para todos.

## Decisão
Mover os bancos para uma coluna `bancos` (jsonb) na tabela `empresas` — assim eles
**herdam o mesmo isolamento das fichas** (cada fiscal só vê os das suas empresas;
contábil das suas; gestora tudo). **Liberar incluir/alterar para a equipe** (nas
empresas que ela já vê), usando a regra de UPDATE da `empresas` (ADR-0005).

## Consequências técnicas
- Nova coluna `empresas.bancos` (jsonb default `[]`).
- `backend-supabase.js`: `getEmpresas` inclui `bancos`; novo `Backend.saveBancos`.
- `index.html`: bancos vêm de `loadRef()`; `loadBancos` virou no-op; `saveBancos`
  grava na tabela; `renderBancos`/`adicionarBanco`/`deletarBanco` sem trava de gestora.
- Migração: 0 (estava vazio); chave antiga `ccc_bancos_v1` esvaziada.
- Obs.: o **status mensal** do banco (recebido/pendente) ainda fica no `ccc_v8`
  (segue a isolação de tarefas, fase futura); aqui isolamos a **definição** da conta.

## Impacto operacional (no escritório)
- A equipe cadastra/edita os bancos das **próprias** empresas, sem depender da gestora.

## Benefício esperado
- ✅ **Qualidade:** dado no lugar certo, colaborativo.
- 🛡️ **Risco:** dado bancário sensível fica **isolado** (não visível entre carteiras).
- ⏱️ **Tempo:** menos vai-e-volta com a gestora.
