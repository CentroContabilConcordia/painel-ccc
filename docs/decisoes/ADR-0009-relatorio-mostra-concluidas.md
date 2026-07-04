# ADR-0009 — Relatório mostra também as empresas concluídas

- **Data:** 2026-07-04
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Ao gerar um relatório com um filtro (ex.: Julho + Status "Concluído" + tarefa
"Simples Nacional (PGDAS-D)"), as **empresas que já fizeram** a tarefa **não
apareciam**. A seção de empresas só listava "Empresas com Pendências" — de
propósito escondia as 100% concluídas.

## Decisão
A seção de empresas passa a **respeitar o filtro** e listar **todas as empresas**
do resultado (não só as pendentes). O título reflete o status filtrado (ex.:
"Empresas — Concluídas"). Removido o limite de 20 (mostra todas), ordenadas por
atrasadas → menos concluídas → nome.

## Consequências técnicas
- `gerarRelatorio()`: `empsPend` (filtro que excluía as concluídas) virou
  `empsList` (todas as empresas do resultado, ordenadas).

## Impacto operacional (no escritório)
- A gestora consegue ver **quais empresas já fizeram** cada tarefa (ex.: quem já
  entregou a Simples Nacional), não só as que têm pendência.

## Benefício esperado
- ✅ **Qualidade:** visão completa (feitas + pendentes) — o relatório mostra o que
  foi pedido.
- ⏱️ **Tempo:** não precisa cruzar informação na mão.
