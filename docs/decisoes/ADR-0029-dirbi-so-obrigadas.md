# ADR-0029 — DIRBI só para as empresas obrigadas

- **Data:** 2026-09-18
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A DIRBI (Declaração de Incentivos, Renúncias, Benefícios e Imunidades de Natureza
Tributária) já existia como tarefa no template fiscal, mas **nem toda empresa é
obrigada**. A Patrícia identificou **4 empresas obrigadas**; as demais devem ficar
como **"não se aplica"**.

## Decisão
- Marca **`ficha.dirbi = true`** nas empresas obrigadas. As 4:
  AGROCOMERCIAL SOBERANA, S.M.G LATICÍNIOS, CLINICA BONNA SALUTE, XAVIER & REIS.
- **Geração de tarefas** (`novasTarefasMes`): a tarefa **DIRBI** nasce
  **"não se aplica"** para todas — **exceto** as empresas com `ficha.dirbi===true`.
  Vale para o mês atual e para os próximos automaticamente.
- **Dados existentes:** nas tarefas já geradas (blob `ccc_v8`, setor fiscal), a DIRBI
  das empresas **não obrigadas** foi virada para "não se aplica"; a das 4 obrigadas
  foi mantida. Backups das fichas e do blob antes de aplicar.

## Alternativas consideradas
- **Deixar DIRBI pendente pra todas e cada uma marcar N/A à mão:** descartado —
  retrabalho e risco de esquecer; a regra é fixa (4 obrigadas).

## Consequências técnicas
- `index.html`: `novasTarefasMes` força DIRBI→'naoseaplica' quando `ficha.dirbi` não
  é true. Verificado (normal→N/A, obrigada→pendente).
- Dados por script REST (`dirbi.py`, auth gestora): `ficha.dirbi=true` nas 4 (casadas
  por nome) + flip da DIRBI no blob (187 tarefas viraram N/A; 12 das obrigadas
  mantidas). Backups `backup_fichas_pre_dirbi.json` / `backup_ccc_v8_pre_dirbi.json`.

## Impacto operacional (no escritório)
- A DIRBI aparece como pendência **só nas 4 empresas** que realmente entregam; nas
  demais fica "não se aplica" (some do dia a dia). Menos ruído e menos erro.

## Benefício esperado
- 🛡️ **Redução de erros:** ninguém tenta entregar DIRBI de quem não deve.
- ⏱️ **Tempo:** a lista de pendências fiscais fica limpa.
