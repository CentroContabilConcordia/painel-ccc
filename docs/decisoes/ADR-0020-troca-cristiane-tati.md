# ADR-0020 — Saída da Cristiane e entrada da Tati (nova divisão fiscal)

- **Data:** 2026-08-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A Cristiane (fiscal) saiu do escritório e entrou a Tati. A Patrícia passou a nova
lista de divisão (planilha `LISTA EMPRESAS FISCAL 01-09-2026.xls`), a valer por
CNPJ.

## Decisão
- **Tati reaproveita a "vaga" da Cristiane** (id interno `cris`, conta
  `cris@cccpainel.app`). No app, o perfil foi **renomeado de "Cristiane" para
  "Tati"** (só o nome de exibição; id/e-mail seguem `cris`). Evita criar conta nova
  (não temos acesso admin do Supabase).
- **Redistribuição por CNPJ** conforme a planilha (TATI→`cris`, CLEO/GABI/JULIA
  normais): **108 trocas**. Resultado: Cleo 92 · Tati 76 · Gabi 60 · Julia 52.
- Casos de CNPJ divergente/ausente casados por **nome** (conferidos): Cidasc,
  Canesso, Restaurante N&E, Gustavo Casagrande, Rápido Confiança.
- **Sobra/falta relatada antes** (pedido da Patrícia): 0 faltando; 13 sobrando (no
  painel, fora da lista). Destas, **3 inativadas** (AGIMAX, BEHOUSE, ESQUADRITEC —
  "não fazemos mais"; inativadas em vez de excluir, p/ guardar histórico) e **10
  mantidas** com o responsável atual (2 já eram inativas).

## Consequências técnicas / operacionais
- `index.html`: `USUARIOS.cris.nome` e `MEMBROS_FISCAL` (id cris) → "Tati".
- Dados via REST (gestora): `apply_tati.py` (backup antes, dry-run→apply, casa por
  CNPJ + nome exato + aprox só p/ itens sem CNPJ). Backups `_backup_pre_tati_*`.
- ⚠️ **PENDENTE (segurança):** a Patrícia deve **trocar o PIN da conta `cris` no
  Supabase** (Authentication → Users) para **bloquear o acesso da Cristiane**; a Tati
  passa a usar o novo PIN. (Não temos service_role p/ fazer isso via código.)

## Benefício esperado
- ⏱️ Divisão nova aplicada em minutos, por CNPJ, sem retrabalho.
- 🛡️ Histórico preservado (inativar em vez de excluir); acesso da ex-funcionária a
  ser bloqueado no Supabase.
