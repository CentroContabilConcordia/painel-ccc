# ADR-0034 — Número (código) da empresa no Questor ao lado de cada empresa

- **Data:** 2026-09-29
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
As meninas usam o **Questor** no dia a dia e localizam cada cliente pelo **número da
empresa** naquele sistema. A Patrícia pediu que esse número apareça **ao lado de cada
empresa** no painel, para facilitar achar/abrir a empresa no Questor.

## Decisão
- Cada empresa passa a ter um campo **`ficha.codigoQuestor`** (o número da empresa no
  Questor, ex.: `482`).
- **Na lista** (fiscal e contábil), aparece um **selo discreto "Q 482"** ao lado do nome.
- **Na ficha**, um campo **"Código Questor"** (primeiro campo dos Dados Cadastrais),
  editável **só pelas gestoras** (como os demais campos da ficha).
- **Preenchimento inicial** a partir do relatório do Questor "Ficha das Empresas"
  (`Relatorios_Cadastrais_Empresas_...csv`), **pareando por CNPJ** — a regra do projeto.

## Alternativas consideradas
- **Mostrar só na ficha:** descartada — a Patrícia quer o número **ao lado**, visível na
  lista, para achar rápido.
- **Guardar o "empresa/estabelecimento" completo (`482/1`):** guardamos só o **número da
  empresa** (`482`), que é como a equipe identifica; o estabelecimento (matriz/filial) a
  equipe seleciona dentro do Questor.

## Consequências técnicas
- `index.html`: `criarEmpItem` mostra o selo `Q <código>` quando `ficha.codigoQuestor`
  existe; ficha ganha o input `f-codquestor`; `salvarFicha` grava `ficha.codigoQuestor`.
  Só `index.html`. Sintaxe verificada.
- Dados: script REST `import_codquestor.py` (gestora) preenche por **CNPJ completo**
  (confiável), em **simulação por padrão** (`--apply` grava, com backup). Fonte:
  `codigos_questor.json` (288 empresas do relatório de 13/07/2026; 281 com CNPJ).
  - **Filiais** (CNPJ `/0002…`) não vêm no relatório como bloco próprio → o script as
    **sugere pela raiz** (não grava) para a gestora confirmar o estabelecimento.
  - Empresas **cadastradas depois de 13/07** (4 novas, Oeste, etc.) ficam **sem match** →
    código preenchido à mão na ficha (poucas).

## Impacto operacional (no escritório)
- A equipe vê o número do Questor ao lado da empresa e abre/localiza direto no sistema,
  sem procurar por nome.

## Benefício esperado
- ⏱️ **Tempo:** achar a empresa no Questor na hora.
- 🛡️ **Redução de erros:** menos risco de abrir a empresa errada (número confere).

## Follow-up
- Completar à mão o código das empresas novas e confirmar o estabelecimento das filiais.
- (Opcional) incluir "Código Questor" como coluna no Relatório de Cadastro.
