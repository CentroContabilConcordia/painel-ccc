# ADR-0033 — Transferência de empresa com data (responsável fiscal por mês)

- **Data:** 2026-09-29
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Algumas empresas da **Júlia** e da **Gaby** foram **repassadas para a Tati**. A regra
combinada: **até agosto/2026 o histórico continua com quem era responsável** (Júlia/Gaby)
e **de setembro/2026 em diante passa a ser da Tati**. As antigas responsáveis **precisam
continuar enxergando** os meses que foram delas — se deixaram alguma obrigação em aberto,
têm que poder ajustar **no período de sua responsabilidade**.

Antes, cada empresa tinha **um único** responsável fiscal (`fiscal_owner`), sem noção de
tempo — trocar o dono jogaria todo o histórico para o novo responsável.

## Decisão
Cada empresa passa a ter um **histórico de responsável** (`ficha.respHist`), igual em
espírito ao histórico de regime (ADR-0024):

```
respHist = [ {resp:'julia', desde:''}, {resp:'cris', desde:'2026-09'} ]
```
- `desde:''` = desde sempre; a última faixa cujo `desde` ≤ competência é a válida.
- **A carteira de cada pessoa é calculada por mês** (`empresasDoMembro(membro, mês)`):
  agosto mostra a empresa na lista da Júlia/Gaby; setembro em diante, na da Tati.
- As **tarefas de cada competência ficam com o dono daquele mês** (`getMembroKey` roteia
  pelo dono do mês) — agosto grava sob Júlia/Gaby, setembro sob a Tati; nada de histórico
  “migra” de dono.
- **Monitoramento e Relatórios** passam a montar a carteira **por competência** (usam
  `empresasDoMembro(mk, mês)`), então o retrato de cada mês fica fiel.
- Sem `respHist`, tudo funciona como antes (dono atual = `fiscal_owner`).

## Alternativas consideradas
- **Trocar só o `fiscal_owner`** (sem data): descartada — jogaria o histórico de agosto
  para a Tati e tiraria da Júlia/Gaby a visão do que era delas.
- **Passar as empresas só em outubro:** a Patrícia definiu o corte em **setembro**.

## Consequências técnicas
- `index.html`: novo `fiscalOwnerDe` (dono atual, base), `ownerNoMes(emp,mês)` (robusto a
  ordem), `empresasDoMembro(mk,mês)`, e `getMembroKey` roteando pelo dono do mês. Carteira
  (lista fiscal e busca global), contagens dos membros, Monitoramento (`initMonitor`) e
  Relatório de tarefas (`gerarRelatorio`) passam a ser por competência. Relatórios de
  **Cadastro** e **Bancos** (foto atual, sem mês) seguem pelo dono atual.
- Dados: script REST `transf_setembro.py` (gestora) grava `fiscal_owner='cris'` +
  `respHist` nas 27 empresas, pareando por nome (conferido) com **backup** antes; roda em
  **simulação por padrão** (só `--apply` grava). 27 empresas: Júlia (11) + Gaby (16).
- **Acesso (RLS) — obrigatório:** a política de SELECT da tabela `empresas` (`"ver empresas"`)
  passa a incluir as empresas em que a pessoa foi **dona no passado** (`respHist`), além do
  `fiscal_owner` atual. Sem isso, ao virar dona a Tati, a Júlia/Gaby perderiam a visão de
  agosto. Comando (Patrícia roda no SQL editor do Supabase):
  ```sql
  ALTER POLICY "ver empresas" ON empresas
  USING (
    is_gestora()
    OR fiscal_owner = meu_member_id()
    OR meu_setor() = 'contabil'::text
    OR (ficha -> 'respHist') @> jsonb_build_array(jsonb_build_object('resp', meu_member_id()))
  );
  ```
  Só **acrescenta** um OR (não restringe nada) — seguro rodar mesmo antes dos dados; sem
  `respHist` a cláusula não casa com nada. Política atual (rollback):
  `is_gestora() OR (fiscal_owner = meu_member_id()) OR (meu_setor() = 'contabil'::text)`.
  **UPDATE** (`"atualizar empresas"`) fica como está (dono atual/gestora/contábil): editar
  ficha/bancos do estado atual é da nova dona; o passado se ajusta nas **tarefas**, que ficam
  no bloco compartilhado (`ccc_v8`) e não dependem do RLS de `empresas`.

## Impacto operacional (no escritório)
- A partir de setembro, as 27 empresas aparecem na carteira da **Tati**; agosto e antes
  continuam com **Júlia/Gaby**, que seguem vendo e ajustando o período que foi delas.

## Benefício esperado
- ✅ **Qualidade:** histórico fiel — cada mês com seu verdadeiro responsável.
- 🛡️ **Redução de erros:** repasse sem “perder” nem “empurrar” obrigações de meses passados.

## Follow-up
- Impedir edição das antigas responsáveis **além** do seu período (hoje elas veem e podem
  ajustar; a trava por período fica para 2ª etapa, se a Patrícia quiser).
