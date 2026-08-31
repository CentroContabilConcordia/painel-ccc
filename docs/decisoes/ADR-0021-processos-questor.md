# ADR-0021 — Aba "Processos Questor" (manual de procedimentos da equipe)

- **Data:** 2026-08-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A equipe precisava de um lugar único para documentar **os processos do sistema
Questor** (passo a passo), para que **qualquer funcionária** consiga executar um
processo seguindo o manual — reduzindo dependência de quem "já sabe".

## Decisão
Nova aba **"📖 Processos Questor"**, visível a **todos** (gestoras e equipe):
- Lista de **processos**, cada um com **título**, **categoria** (ex.: Fiscal, Folha,
  Cadastro) e **passo a passo** (texto, uma linha por passo).
- **Busca** por título/categoria/conteúdo.
- **Adicionar / editar / excluir** processo — **liberado para toda a equipe**
  (decisão da Patrícia: colaboração aberta).
- Guardado no banco (chave `ccc_processos_v1`), compartilhado — todos veem a mesma
  versão e sincroniza em tempo real.
- **v1 em texto.** Prints/imagens podem entrar numa evolução futura.

## Consequências técnicas
- `index.html`: painel `#painel-processos`; aba na `nav` (todos); `trocarView`
  trata `processos`; `loadProcessos`/`saveProcessos` (kv_store `ccc_processos_v1`);
  `renderProcessos`/`renderProcListaSomente` + `novoProcesso`/`editarProcesso`/
  `salvarProcesso`/`excluirProcesso`; conteúdo com escape de HTML. Só `index.html`.
- Verificado no navegador (criar/listar/buscar/passos preservados; sem erros).

## Impacto operacional (no escritório)
- Manual vivo dos processos do Questor, dentro do próprio painel; qualquer pessoa
  segue o passo a passo e também contribui melhorando os processos.

## Benefício esperado
- ⏱️ **Tempo:** menos "me ensina como faz"; a pessoa consulta e executa.
- ✅ **Qualidade/padronização:** processos feitos do mesmo jeito por todas.
- 🛡️ **Continuidade:** conhecimento não fica só na cabeça de uma pessoa.
