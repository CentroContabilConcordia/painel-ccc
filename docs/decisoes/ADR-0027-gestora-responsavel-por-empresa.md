# ADR-0027 — Gestora responsável por empresa (a quem se reportar)

- **Data:** 2026-09-16
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A equipe precisa saber, por empresa, **a qual gestora se reportar** (Diane ou Patty)
quando precisa de ajuda ou informação. Isso já existia numa planilha fiscal (coluna
"RESPONSÁVEL"), mas não aparecia no painel.

## Decisão
- Novo campo **`ficha.gestora`** (`patty` | `diane` | vazio).
- **Na lista de empresas** (fiscal e contábil), cada empresa mostra um selo
  **"👤 Gestora: <nome>"** na cor da gestora — visão imediata para toda a equipe.
- **Na ficha**, campo **"Gestora responsável"** (select Patty/Diane), editável pelas
  gestoras (como os demais responsáveis).
- **Importação inicial por CNPJ** da `LISTA EMPRESAS FISCAL 01-09-2026.xls`
  (coluna RESPONSÁVEL): 269 empresas definidas (Diane 150, Patty 119); 19 ficaram sem
  gestora (fora da lista / sem CNPJ) — ajustáveis na ficha. Backup antes de aplicar.

## Consequências técnicas
- `index.html`: `getFicha` ganha `gestora:''`; `criarEmpItem` mostra o selo;
  `renderFicha` ganha o select `f-gestora`; `salvarFicha` grava `ficha.gestora`.
  Só `index.html`. Verificado no navegador (selo na lista com cor; campo pré-selecionado
  na ficha).
- Dados: `PATCH /rest/v1/empresas` (ficha) casando por CNPJ, via script REST
  (`import_gestora.py`), com backup `backup_empresas_pre_gestora.json`.

## Impacto operacional (no escritório)
- A equipe vê na hora com qual gestora falar por empresa; as gestoras ajustam pela
  ficha quando mudar.

## Benefício esperado
- ✅ **Clareza:** cada empresa com sua gestora à vista.
- ⏱️ **Tempo:** menos "com quem falo?" — a resposta está na tela.
