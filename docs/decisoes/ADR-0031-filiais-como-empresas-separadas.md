# ADR-0031 — Filiais como empresas separadas

- **Data:** 2026-09-23
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Algumas empresas têm **filiais** em outras cidades/estados (RS, AM, MT, Joaçaba,
Videira). Como as filiais têm **obrigações diferentes** (Inscrição Estadual própria,
ISS do município, obrigações estaduais distintas), a Patrícia decidiu que cada filial
deve ter **controle próprio**.

## Decisão
Cada filial é cadastrada como uma **empresa separada** no painel (não agrupada dentro
da matriz):
- **Nome:** `<matriz curta> — FILIAL <cidade>` (ex.: "XAVIER & REIS — FILIAL JOAÇABA").
- **Herda da matriz** (por CNPJ raiz): **carteira** (fiscal_owner), **regime** (Simples
  é da pessoa jurídica toda) e **gestora**.
- **Ficha própria:** CNPJ da filial, CNAEs (dos cartões da Receita), endereço, cidade,
  telefone; **checklist de tarefas/obrigações próprio** (o motivo da separação).
- **Sugestões automáticas** conforme o regime herdado: Simples → anexo por CNAE;
  Lucro Presumido/Real → PIS/COFINS/IRPJ/CSLL/ISS por CNAE (âmbar, pra conferir).
- **Marca `ficha.filial=true`:** na lista aparece um selo **FILIAL** + 📍cidade, e
  fica junto da matriz (mesmo nome) + aparece na busca geral.

## Alternativas consideradas
- **Agrupar sob a matriz** (1 empresa, seção de estabelecimentos): descartada — as
  filiais têm obrigações próprias, então precisam de checklist separado.

## Consequências técnicas
- `index.html`: `criarEmpItem` mostra o selo FILIAL + cidade quando `ficha.filial`.
  Nenhuma outra mudança — cada filial é uma empresa comum.
- Cadastro por script REST (`cadastrar_filiais.py`, auth gestora): 6 filiais, herdando
  owner/regime/gestora da matriz (por CNPJ raiz), CNAEs dos cartões + sugestões,
  dedup por CNPJ. **Inscrição Estadual** não vem no cartão — fica em branco.

## Impacto operacional (no escritório)
- Cada filial tem seu próprio acompanhamento de obrigações, do jeito que a realidade
  (estados/municípios diferentes) exige. Fáceis de achar (nome + busca geral + selo).

## Benefício esperado
- ✅ **Qualidade:** obrigações de cada estabelecimento controladas separadamente.
- 🛡️ **Redução de erros:** não mistura obrigações de matriz e filial.
