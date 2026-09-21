# ADR-0030 — Tributos por CNAE no Lucro Presumido/Real (PIS/COFINS/IRPJ/CSLL/ISS)

- **Data:** 2026-09-21
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
No Simples, cada CNAE tem o **Anexo** (ADR-0028). No **Lucro Presumido/Real** o Anexo
não se aplica — o que importa por atividade é o tratamento de **PIS, COFINS, IRPJ,
CSLL e ISS**. A Patrícia pediu que, nesses regimes, apareçam essas opções ao lado de
cada CNAE, para a equipe classificar e errar menos.

## Decisão
Na tabela de CNAEs da ficha, as colunas mudam conforme o **regime**:
- **Simples Nacional:** coluna **Anexo Simples** (como já era).
- **Lucro Presumido / Lucro Real:** somem o Anexo e aparecem **5 colunas**:
  **PIS · COFINS · IRPJ · CSLL · ISS** (dropdowns por atividade).
- **MEI / Imune:** só a observação.
- Trocar o regime na ficha alterna as colunas na hora.

**Opções:** PIS/COFINS = Cumulativo · Não cumulativo · Monofásico · Alíquota zero ·
Substituição · Não se aplica. IRPJ = 1,6% · 8% · 16% · 32% · Não se aplica.
CSLL = 12% · 32% · Não se aplica. ISS = 2% · 3% · 4% · 5% · Fixo · Não se aplica.

**Sugestão automática (âmbar, conferir):** PIS/COFINS pelo regime (Real→Não cumulativo,
Presumido→Cumulativo); IRPJ/CSLL pela atividade do CNAE (comércio/indústria → 8%/12%;
serviços → 32%/32%); ISS em branco. A gestora confere e confirma (mudar o valor ou
"✓ Confirmar sugestões" limpa o âmbar). **Só gestoras editam.**

## Consequências técnicas
- `index.html`: constantes de opções + `_tribSugerido`; `renderCnaesLista` monta as
  colunas por regime (lê o `f-regime` ao vivo); `cnaeSetTrib` (grava tributo + limpa
  `tribSug`); `cnaeConfirmarSugeridos` limpa anexoSug **e** tribSug; `atualizarAnexo`
  re-renderiza a lista ao trocar o regime. Dados por CNAE: `c.pis/cofins/irpj/csll/iss`
  + `c.tribSug`. Verificado no navegador.
- Sugestões preenchidas em massa por `import_trib_sug.py` (24 empresas LP/LR, 127
  CNAEs; preserva o que já estiver confirmado; backup `backup_fichas_pre_trib.json`).

## Impacto operacional (no escritório)
- No Lucro Real/Presumido a equipe vê, por atividade, o tratamento de cada tributo
  (já sugerido, pra conferir) — menos erro de apuração/classificação.

## Benefício esperado
- 🛡️ **Redução de erros** na apuração por atividade.
- ⏱️ **Tempo:** sugestão adianta; a equipe só confere.
