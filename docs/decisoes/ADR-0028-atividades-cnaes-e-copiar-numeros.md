# ADR-0028 — Ficha: Atividades (CNAEs) por empresa + copiar CNPJ/IE só números

- **Data:** 2026-09-17
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Para a equipe classificar a nota certa e evitar erro de enquadramento, a Patrícia
pediu que a seção **Regime Tributário** da ficha mostre **todos os CNAEs da empresa**,
com o **anexo do Simples** e uma **observação** ao lado de cada atividade — sem precisar
anexar o cartão CNPJ de cada empresa. Também pediu um jeito de **copiar o CNPJ e a
Inscrição Estadual só com os números** (sem ponto, barra ou traço) para colar no
Questor/Receita.

## Decisão
**1. Atividades (CNAEs) por empresa** (substitui as antigas caixinhas "Anexos Simples"):
- Lista por atividade: **CNAE (código + descrição)**, **Principal** (⭐), **Anexo do
  Simples** (select) e **Observação** ("o que adequar"). `ficha.cnaes = [{codigo,desc,
  principal,anexo,obs}]`.
- **Só as gestoras editam** (anexo/observação/principal/adicionar/remover); a equipe
  **vê** tudo em modo leitura. O anexo é marcado à mão (é classificação contábil, não
  vem pronto). Os `ficha.anexos`/`ficha.anexo` (compat relatórios) passam a ser
  **derivados** dos anexos marcados nos CNAEs.
- **Preenchimento automático dos CNAEs**: puxados da **base pública da Receita**
  (BrasilAPI, fallback MinhaReceita) por CNPJ — **não** do site cnpjreva (que exige
  CAPTCHA e não pode ser automatizado). Reprocessável sem perder anexo/obs já marcados.

**2. Copiar CNPJ / Inscrição Estadual só com números:** botão **📋** ao lado dos
campos; copia apenas os dígitos. Disponível a **todos** (copiar não é editar).

## Alternativas consideradas
- **Puxar do cnpjreva (site da Receita):** descartado — exige CAPTCHA; não se burla
  CAPTCHA. Os mesmos dados vêm da base pública sem CAPTCHA.
- **Sugerir o anexo automaticamente por CNAE:** descartado — não há mapa confiável;
  chutar induziria ao erro que se quer evitar. Fica manual (gestoras).
- **Campo do CNPJ guardar só dígitos:** descartado — perde legibilidade; o botão de
  copiar resolve mantendo o campo formatado.

## Consequências técnicas
- Só `index.html`: `getFicha` ganha `cnaes:[]`; seção de CNAEs (`renderCnaesLista`
  + `cnaeAdd/Del/Set/Principal`, todas com guarda `isGestora`); `salvarFicha` deriva
  anexos via `_cnaeDerivaAnexos`; botão/《função》`copiarSoNumeros`/`_copiaFallback`.
  Verificado no navegador (gestora edita, equipe só lê; copia só dígitos).
- Importação dos CNAEs por script REST (`import_cnaes.py`, auth gestora, UA de
  navegador p/ passar pelo Cloudflare da API), com backup e merge que preserva
  anexo/obs. As 4-5 empresas recém-abertas (2026) podem ainda não constar na base
  pública — CNAE delas entra manual ou numa reimportação futura.

## Atualização (2026-09-17) — Sugestão automática de anexo (conferir)
A pedido da Patrícia, o anexo passa a vir **pré-preenchido como sugestão** pela regra
geral da LC 123, pra equipe **só conferir**: Comércio (CNAE div. 45-47)→Anexo I;
Indústria (05-09, 10-33)→Anexo II; Construção (41-43)→Anexo IV; demais serviços→Anexo
III. Cada sugestão fica marcada `anexoSug:true` e aparece em **âmbar com etiqueta
"sugestão"** + aviso (serviços dependem do Fator R — pode ser III ou V); ao a gestora
**mudar o anexo** ou clicar **"✓ Confirmar anexos sugeridos"**, o `anexoSug` some
(vira confirmado). Funções `_anexoSugerido`, `cnaeConfirmarSugeridos`; preenchido em
massa por `import_anexo_sug.py` (preserva anexos já confirmados). **Deixado claro à
Patrícia:** é sugestão pela regra geral; o enquadramento final é do escritório.

## Impacto operacional (no escritório)
- A equipe vê, por empresa, as atividades com anexo e observação — classifica a nota
  certa e erra menos no enquadramento. Copiar CNPJ/IE limpo agiliza o dia a dia.

## Benefício esperado
- 🛡️ **Redução de erros:** enquadramento e lançamento de nota mais seguros.
- ⏱️ **Tempo:** CNAEs preenchidos automático; copiar sem limpar à mão.
- ✅ **Qualidade:** ficha reflete todas as atividades da empresa.
