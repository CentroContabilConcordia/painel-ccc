# ADR-0032 — Prazos e datas de conclusão nas tarefas (fiscal)

- **Data:** 2026-09-28
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
As tarefas fiscais não mostravam **prazo** nem **quando foram feitas**. A Patrícia
pediu, de forma prática, que cada tarefa mostre seu **vencimento**, destaque o que
está **atrasado**, e registre a **data de conclusão** — tudo **dentro da própria aba
de Tarefas** (não uma tela nova).

## Decisão
- **Prazo por obrigação, calculado automático por mês** (sem digitar): cada tarefa do
  `PAD_FISCAL` tem um vencimento configurado (`PRAZO_CONFIG`) e o painel calcula a data
  de cada competência. Documentos/fechamentos = **último dia do mês** (interno).
- **Regra de dia não útil:** cai em fim de semana/feriado → **posterga** para o próximo
  dia útil, **exceto INSS e Funrural** que **antecipam** para o dia útil anterior.
  Feriados nacionais (fixos + móveis via Páscoa) entram no cálculo.
- **Destaque automático** em cada tarefa: 🔴 atrasada (Xd), ⚠ vence hoje, 🟡 vence em
  Xd (≤7 dias), ou a data do vencimento; e **resumo no topo** (atrasadas · vence essa
  semana · concluídas).
- **Data de conclusão automática:** ao marcar concluída, grava `t.concluidoEm` (some se
  reabrir); mostra "✓ DD/MM · no prazo / c/ atraso".

### Prazos configurados (vencimento no mês seguinte à competência, salvo indicado)
Simples/DAS 20; ICMS(SC) 10; **ICMS-ST/DIFAL 10 do 2º mês subseq.**; PIS/COFINS 25;
IRPJ/CSLL último dia útil; **ISS Concórdia 15**; INSS/Funrural 20 (antecipam);
Retenções Federais último dia útil; DIME(SC) 10; GIA(SC) 10; SPED Fiscal 20; EFD
Contribuições 14; DCTF 15; EFD-Reinf 15; DeSTDA 28; DIRBI 20.

## Consequências técnicas
- `index.html`: `PRAZO_CONFIG`, motor de datas (`_pascoa`/`_feriadosAno`/`_diaUtil`/
  `_ajustaUtil`/`prazoDaTarefa`/`_prazoInfo`/`_prazoHtml`); `renderTarefas` mostra o
  prazo por tarefa + resumo; `toggleT`/`mudarStatus` gravam `concluidoEm`. Só
  `index.html`. Verificado: cálculo (fim de semana, feriado 12/10, INSS/Funrural
  antecipam) e render (atraso, vence em Xd, concluída no prazo).
- Prazos só nas tarefas com config (fiscal). Contábil fica sem prazo por ora.

## Impacto operacional
- A equipe vê o vencimento de cada obrigação, o que está atrasado/vencendo, e quando
  cada tarefa foi feita — sem digitar prazos.

## Benefício esperado
- 🛡️ **Menos risco de perder prazo.**
- ⏱️ **Visão imediata** do que corre risco no mês.

## Follow-up
- Filiais em outros estados: prazos próprios (ajuste por empresa) — a fazer.
- 2ª etapa: ordenar por prazo + resumo no Painel de Monitoramento das gestoras.
- Feriados municipais de Concórdia (se quiserem).
