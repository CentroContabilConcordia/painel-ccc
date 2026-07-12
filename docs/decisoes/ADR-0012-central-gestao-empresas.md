# ADR-0012 — Central de gestão de empresas (Administração)

- **Data:** 2026-07-12
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A gestão de empresas estava **espalhada**: renomear ficava na ficha, cadastrar na
Administração, e **reatribuir o responsável nem existia**. A Patrícia sugeriu
centralizar tudo numa "base" — decisão de organização acertada.

## Decisão
A aba **Empresas** da Administração virou uma **central de gestão** (só gestoras):
- **Lista de todas as empresas** com **busca**.
- Por empresa: **trocar o responsável fiscal** (dropdown — reatribuir), **✏️
  Renomear**, **🗑️ Excluir**.
- **Cadastrar nova** (mantido).
- **Correção junto:** criado `EMP_GAB` — a **Gabriela** passou a ter "gaveta" de
  empresas, então dá para **reatribuir empresas a ela** (ela volta 21/07).
- Renomear/Excluir continuam **também na ficha** (conveniência), sem duplicar dados.

## Consequências técnicas
- `backend-supabase.js`: `Backend.setFiscalOwner(nome, owner)`.
- `index.html`: `EMP_GAB` (declaração + `MEMBROS_FISCAL` + `fill` no `loadRef`);
  `renderAdmEmpLista()` + `admRenomear/admExcluir/admTrocarResp` (por índice, para
  não sofrer com nomes que têm aspas/&).
- **Trocar responsável migra as tarefas fiscais** (move `db.fiscal[antigo][emp]` →
  `db.fiscal[novo][emp]`) — nada se perde.
- **Backup completo** (269 empresas + fichas + tarefas) feito antes.
- Verificado no navegador com empresa de teste; dados reais intactos.

## Impacto operacional (no escritório)
- Toda a gestão de empresas num lugar só; a redistribuição de carteira (ex.: para a
  Gabriela) é feita pela gestora, sem suporte técnico.

## Benefício esperado
- ⏱️ **Tempo:** gestão centralizada e rápida.
- ✅ **Qualidade/organização:** um lugar oficial, menos confusão.
- 🛡️ **Risco:** reatribuição preserva histórico (migra tarefas); backup antes.
