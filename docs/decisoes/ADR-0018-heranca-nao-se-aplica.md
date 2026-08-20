# ADR-0018 — Herança automática do "não se aplica" entre meses

- **Data:** 2026-08-20
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Muitas tarefas **não se aplicam** a certas empresas por característica fixa
(ex.: empresa do **Simples** não tem PIS/COFINS/ICMS-ST; empresa de **serviço**
não tem IPI). A equipe marcava isso como "não se aplica" (N/A) **todo mês, na mão**
— repetitivo e sujeito a esquecimento.

## Decisão
Quando as tarefas de um **mês novo** são criadas para uma empresa, o sistema herda
automaticamente as marcações de **"não se aplica"** do **mês anterior** mais recente
com dados. Regras:
- **Só o N/A é herdado.** As demais tarefas nascem **"pendente"** (o trabalho do mês
  zera normalmente).
- É um **padrão editável**: se a empresa mudar (ex.: regime), a equipe marca/desmarca
  na hora.
- Vale para **fiscal e contábil**, em todos os meses seguintes.

## Consequências técnicas
- `index.html`: `statusNaAnterior()` (lê o N/A do mês anterior) + `novasTarefasMes()`
  (monta as tarefas já com o N/A herdado). Usadas nos 2 pontos que criam tarefas
  (`selecionarEmpresa` e `navMes`). Só `index.html`.
- **Ajuste único (backfill):** agosto/2026 já havia sido criado "no zero" para ~34
  empresas antes desta mudança; rodado `backfill_na.py` que aplicou o N/A de julho a
  elas — **528 marcações**, mudando só de `pendente`→`naoseaplica`, sem tocar no que já
  fora trabalhado. Backup do `ccc_v8` antes (`_backup_pre_na_*`).

## Impacto operacional (no escritório)
- A equipe deixa de remarcar "não se aplica" todo mês; abre o mês e as tarefas que
  não valem para a empresa já vêm marcadas.

## Benefício esperado
- ⏱️ **Tempo:** economiza dezenas de marcações manuais por mês.
- 🛡️ **Redução de erros:** evita esquecer de marcar (e apurar tributo que não existe).
