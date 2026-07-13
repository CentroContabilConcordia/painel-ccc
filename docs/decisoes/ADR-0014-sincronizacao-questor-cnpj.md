# ADR-0014 — Sincronização de empresas com o Questor (por CNPJ) + endereço + status Ativa/Inativa

- **Data:** 2026-07-13
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
O cadastro de empresas muda o tempo todo (novas entram, nomes/endereços mudam,
algumas saem). A **única coisa que não muda é o CNPJ**. A Patrícia pediu para, a
partir de uma exportação do **Gerenciador do Questor**, manter o painel em dia
sempre casando **pelo CNPJ**.

## Decisão
1. **Campos de endereço na ficha:** Endereço, Complemento, Bairro, Estado (UF), CEP
   (telefone, município, CNAE, natureza e inscrições já existiam). **Sem sócios**
   (decisão da Patrícia — escopo "Lista + dados da empresa").
2. **Status Ativa/Inativa** (`ficha.ativo`, padrão = ativa): empresa que sai da lista
   de ativas do Questor pode ser marcada **Inativa** — some do dia a dia, mas fica
   guardada com tudo e **reativa em 2 cliques**. **Nunca apaga.** Selo na ficha e na
   lista, botão Inativar/Reativar (gestora), filtro "Mostrar inativas".
3. **Sincronização (rodada por mim, sob demanda):** leio o relatório do Questor
   (formato "ficha despejada", cp1252), caso **pelo CNPJ**, e monto um **resumo para
   a Patrícia aprovar** (novas / renomear / atualizar dados / inativar) **antes** de
   gravar. **Backup completo antes.** O **responsável fiscal nunca é sobrescrito**
   (é decisão interna do escritório, não vem do Questor); tarefas, observações e
   bancos também não.
4. **Casos sem CNPJ no painel:** casados por nome; quando ambíguo (empresa "nova"
   que pode ser uma antiga renomeada), **a Patrícia decide** um a um (evita
   duplicata e preserva histórico). Renomear migra as tarefas.

## Consequências técnicas
- `index.html`: campos de endereço em `getFicha/renderFicha/salvarFicha`; helpers
  `empAtiva()`, `toggleAtivaEmpresa()`, `toggleMostrarInativas()`; filtro de inativas
  nas listas fiscal/contábil + selo; selo na Central de Gestão. Sem mudança em
  `backend-supabase.js`/`config.js` → **sem bump de `?v`**.
- Sincronização usa as funções já existentes do Backend (`addEmpresa`,
  `renameEmpresa`, `saveFicha`, `setFiscalOwner`). Empresas novas entram **sem
  responsável fiscal** — a gestora distribui na Central de Gestão (ADR-0012).
- 1ª rodada (jul/2026): 288 ativas no Questor × 269 no painel → ~29 novas, 10
  renomear, 4 inativar, 7 mantidas ativas, ~255 endereços. Backup antes.

## Impacto operacional (no escritório)
- O painel passa a refletir a realidade do Questor sem digitação manual, e ganha
  endereço. Empresas que saem ficam arquivadas (inativas), não somem.

## Benefício esperado
- ⏱️ **Tempo:** nada de recadastrar/renomear na mão.
- ✅ **Qualidade:** dados sempre em dia; histórico preservado ao renomear.
- 🛡️ **Risco:** casa por CNPJ, resumo aprovado antes de gravar, backup antes, e
  inativar não apaga.
