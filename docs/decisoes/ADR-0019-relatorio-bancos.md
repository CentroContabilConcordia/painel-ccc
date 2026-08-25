# ADR-0019 — Relatório de Bancos Cadastrados

- **Data:** 2026-08-25
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Depois do Relatório de Cadastro das Empresas (ADR-0016), a Patrícia pediu o mesmo
tipo de relatório para os **bancos cadastrados** — para conferir contas, agências e
como cada extrato chega (Acesso × Cliente envia).

## Decisão
Novo card **"Bancos Cadastrados"** na aba Relatórios, no mesmo estilo do de empresas:
- **Filtro:** Responsável Fiscal, Regime, busca por nome de empresa.
- **Campos selecionáveis:** Agência, Conta, Origem do extrato (todos marcados por
  padrão). Colunas fixas: **Empresa** e **Banco**.
- Como uma empresa pode ter **vários bancos**, a tabela lista **um banco por linha**.
  Empresas sem banco não aparecem. Mostra a contagem (bancos · empresas).
- **Gerar / Imprimir-PDF / Exportar Excel.** A origem do extrato aparece por extenso
  ("Acesso (escritório)" / "Cliente envia").

## Consequências técnicas
- `index.html`: card `#rel-banco-wrap`, `CAMPOS_BANCO`, `renderCamposBanco`,
  `gerarRelatorioBancos`, `imprimirRelatorioBancos`, `exportarRelatorioBancosCSV`,
  `valorCampoBanco`. Impressão isolada por classe no body (`imp-banco`) — cada um dos
  3 relatórios imprime só o seu. Só `index.html`.
- Verificado no navegador (dados de teste): 1 linha por banco, múltiplos bancos por
  empresa, origem por extenso, empresa sem banco omitida.

## Impacto operacional (no escritório)
- Conferência rápida dos bancos por empresa, e visão de quais extratos dependem do
  cliente — exporta pra Excel / imprime.

## Benefício esperado
- ⏱️ **Tempo:** lista de bancos pronta sem montar na mão.
- ✅ **Qualidade:** dados direto do cadastro, sempre atualizados.
