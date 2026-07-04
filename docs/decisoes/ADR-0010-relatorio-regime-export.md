# ADR-0010 — Relatórios: filtro por Regime + Exportar/Imprimir

- **Data:** 2026-07-04
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A gestora pediu para **filtrar os relatórios por regime tributário**
(Simples Nacional / Lucro Presumido / Lucro Real) e para **exportar/imprimir**
o relatório.

## Decisão
- **Filtro por Regime:** novo campo no relatório, preenchido com os regimes reais
  das fichas. Ao gerar, empresas fora do regime escolhido são ignoradas
  (comparando com `ficha.regime`).
- **Exportar Excel:** botão que baixa um **CSV** (UTF-8 com BOM, separador `;` —
  abre certinho no Excel BR) com a lista de empresas do relatório.
- **Imprimir / PDF:** botão que chama a impressão do navegador com um **CSS de
  impressão** que mostra **só o relatório** (esconde menu, filtros, cabeçalho).

## Consequências técnicas
- `gerarRelatorio()`: lê `regimeFiltro`; guarda `window._relData` para o export.
- Novas funções `imprimirRelatorio()` e `exportarRelatorioCSV()`; bloco `@media print`.
- Verificado: filtro separa corretamente (Simples 46 + Presumido 6 + Real 1 = 53 total).

## Impacto operacional (no escritório)
- A gestora analisa por regime e leva o resultado para Excel ou papel/PDF —
  útil para reuniões, conferências e arquivo.

## Benefício esperado
- ⏱️ **Tempo:** análise por regime e exportação em 1 clique.
- ✅ **Qualidade:** relatórios prontos para compartilhar/imprimir.
