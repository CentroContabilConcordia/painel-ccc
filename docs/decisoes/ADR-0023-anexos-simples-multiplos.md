# ADR-0023 — Anexos do Simples Nacional: seleção múltipla

- **Data:** 2026-09-10
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
No Simples Nacional, uma empresa com **várias atividades** pode se enquadrar em
**mais de um anexo** (tributações diferentes por atividade). O campo "Anexo Simples
Nacional" na ficha só deixava escolher **um**.

## Decisão
O campo virou **múltipla escolha**: caixinhas (checkboxes) para os 5 anexos (I a V),
podendo marcar **um ou mais**. Guardado em `ficha.anexos` (lista). Mantido também
`ficha.anexo` como texto (anexos separados por vírgula) para **compatibilidade** com
o que já existia e com o Relatório de Cadastro. Ao abrir uma ficha antiga (anexo
único em texto), as caixinhas já vêm marcadas corretamente.

## Consequências técnicas
- `index.html`: `getFicha` ganha `anexos:[]`; em `renderFicha`, o `<select>` de anexo
  virou grupo de checkboxes (`.f-anexo-chk`), pré-marcadas por `ficha.anexos` (ou pelo
  `ficha.anexo` antigo); `salvarFicha` grava `ficha.anexos` (lista) + `ficha.anexo`
  (texto juntado). Só `index.html`. Verificado no navegador (marca vários, salva,
  compat com o antigo; sem erros).

## Benefício esperado
- ✅ **Qualidade:** a ficha reflete a realidade (empresa em vários anexos).
- ⏱️ **Tempo:** menos retrabalho/erro de enquadramento.
