# ADR-0017 — Painel abre no mês anterior (competência)

- **Data:** 2026-08-18
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Na rotina de um escritório contábil, o trabalho é **retroativo**: em agosto se faz a
competência de **julho**. Antes o painel abria no **mês atual**, obrigando a equipe a
"voltar um mês" toda vez.

## Decisão
Ao abrir/entrar, o painel passa a usar como **mês padrão o mês anterior**
(ex.: agosto → julho; janeiro → dezembro do ano anterior). Vale para:
- as **tarefas** (operacional) e o **Painel de Monitoramento** (usam `mesAtual`);
- o **filtro de mês dos Relatórios** (vem já no mês anterior selecionado).
A **navegação de mês** (setas ‹ ›) continua igual — dá pra ir ao mês atual ou a
qualquer outro; só muda o mês exibido **por padrão**.

## Consequências técnicas
- `index.html`: em `iniciarApp`, `mesAtual = mês anterior` (`new Date(ano, mes-1, 1)`);
  em `initRelatorios`, o `<select>` de mês vem com o item **i===1** (mês anterior)
  selecionado. Só `index.html`.
- Verificado no navegador: em ago/2026 o painel abre em Julho/2026 (tarefas e
  relatórios).

## Impacto operacional (no escritório)
- A equipe já abre no mês que está trabalhando — menos cliques, menos risco de
  lançar no mês errado.

## Benefício esperado
- ⏱️ **Tempo:** não precisa voltar um mês toda vez.
- 🛡️ **Redução de erros:** evita mexer no mês errado por engano.
