# ADR-0016 — Relatório de Cadastro das Empresas (campos da ficha selecionáveis)

- **Data:** 2026-08-18
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Os relatórios existentes eram de **desempenho** (tarefas, % concluído). A Patrícia
precisava de um relatório **de cadastro**: a **lista das empresas** com os **dados
da ficha** que ela escolher (CNPJ, endereço, regime, telefone, etc.) — para
conferências, listas de CNPJ, mailing, etc.

## Decisão
Novo card **"Cadastro das Empresas"** na aba Relatórios, com:
- **Filtro de empresas:** Responsável Fiscal (todas / uma pessoa), Regime, e busca
  por nome.
- **Campos selecionáveis** (caixinhas): CNPJ, Regime, Município, Telefone, Endereço,
  Complemento, Bairro, Estado, CEP, CNAE, Natureza Jurídica, Insc. Estadual/Municipal,
  Anexo Simples, Data de Abertura, Resp. Fiscal, Resp. Contábil. (Padrão marcado:
  CNPJ, Regime, Município.) "Empresa" (nome) é sempre a 1ª coluna.
- **Gerar / Imprimir-PDF / Exportar Excel.** O "Resp. Fiscal" na tabela usa o dono
  real (fiscal_owner), não o campo informativo da ficha.

## Consequências técnicas
- `index.html`: card novo (`#rel-cad-wrap`), `CAMPOS_CAD`, `renderCamposCad`,
  `gerarRelatorioCadastro`, `imprimirRelatorioCadastro`, `exportarRelatorioCadastroCSV`,
  helpers `valorCampoCad`/`donoFiscalDe`. Impressão isolada por classe no body
  (`imp-cad`/`imp-task`) p/ imprimir só o relatório gerado. Só `index.html`.
- Verificado no navegador (gerou 77 empresas da Cris com CNPJ/Regime/Município/
  Telefone/Endereço; dados reais).

## Impacto operacional (no escritório)
- A equipe monta listas de empresas com os dados que precisar, na hora, e exporta
  pra Excel / imprime.

## Benefício esperado
- ⏱️ **Tempo:** listas de cadastro prontas sem montar na mão.
- ✅ **Qualidade:** dados vêm direto da ficha, sempre atualizados.
