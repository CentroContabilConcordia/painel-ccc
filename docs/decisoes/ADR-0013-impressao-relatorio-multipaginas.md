# ADR-0013 — Impressão do relatório em várias páginas

- **Data:** 2026-07-13
- **Status:** Aprovada
- **Aprovado por:** Patrícia (bug reportado por ela)

## Contexto
Ao imprimir o relatório de empresas **concluídas** (ex.: Simples Nacional), saía
**só uma página**, mesmo havendo mais empresas feitas do que cabe numa folha. O
relatório na tela mostrava todas — o corte acontecia **só na impressão**.

## Decisão
Corrigir o CSS de impressão (`@media print`). A caixa do relatório (`.rel-wrap`)
tinha **altura fixa de uma tela** (`height:calc(100vh - 108px)`) com rolagem
interna — ótimo na tela, mas na impressão isso **corta tudo o que passa de uma
página**. Na impressão agora:
- `.rel-wrap`, `#painel-relatorios`, `.app`, `html/body` → `height:auto`,
  `max-height:none`, `overflow:visible` (o conteúdo flui por quantas páginas
  precisar).
- `.rel-table tr` → `break-inside:avoid` (não corta uma empresa no meio ao virar a
  página) e `thead` repetido no topo de cada página.

## Consequências técnicas
- Só `index.html`, bloco `@media print`. **Nada** de JS/banco muda; comportamento
  na tela é o mesmo. Sem bump de `?v` (regra de cache é só p/ config.js /
  backend-supabase.js).
- Verificado no navegador: as 11 regras de impressão parseiam sem erro e a altura
  fixa do relatório é desfeita no modo impressão.

## Impacto operacional (no escritório)
- Imprimir/gerar PDF do relatório agora sai **completo**, em todas as páginas.

## Benefício esperado
- ⏱️ **Tempo:** não precisa tentar imprimir várias vezes.
- ✅ **Qualidade:** o relatório impresso reflete o que está na tela — nada some.
