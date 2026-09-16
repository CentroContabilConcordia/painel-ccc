# ADR-0026 — Controle Anual do Contábil (visão do ano por empresa/mês)

- **Data:** 2026-09-16
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
O contábil controlava num Excel (`Controle_Contabilidade_Mensal.xlsx`, uma aba por
ano) quais meses de cada empresa já tinham a contabilidade feita, e num segundo Excel
(`BALANCOS_2025...`) a entrega de Balanço/ECD/ECF. Arquivos na rede travam, se
perdem e não dão visão ao vivo. A Patrícia pediu **essa visão dentro do painel** —
não um relatório de imprimir, mas uma **tela interativa**.

## Decisão
Nova opção no menu **"📅 Controle Anual"** (visível a todos), que abre um **quadro**
empresa × mês do ano:
- Linhas = empresas ativas; colunas **JAN…DEZ** com 3 estados por clique:
  ⬜ Não feito · ✅ Feito · ➖ Não se aplica.
- **+ 3 colunas anuais**: **Balanço · ECD · ECF** (mesmos 3 estados) + **Observação**.
- **Anos:** só **2025 e 2026** (seletor).
- **Totais por coluna** (linha "✓ feitas") = a visão geral pedida.
- **Filtros:** buscar empresa · só pendentes · por responsável.
- Coluna da empresa e cabeçalho **fixos** ao rolar; grade rola na horizontal.
- **Ao vivo e compartilhado** (kv_store `ccc_contab_anual_v1`); marcação **manual**
  (clique). Todos veem/editam, como nos Processos.

### Importação inicial (uma vez)
- **Meses (2025/2026):** de `Controle_Contabilidade_Mensal` — `CONF/OK/X` → ✅,
  `-` → ➖, vazio → ⬜.
- **Balanço/ECD/ECF de 2025:** de `BALANCOS_2025`, casando **por CNPJ**; **Simples
  Nacional (SN) → ECF = ➖** (Simples não entrega ECF).
- **2026 anuais em branco** (só serão feitos em 2027).
- **Casamento por CNPJ** via ponte "código Questor → CNPJ" (da planilha de balanços)
  + fallback por nome. Resultado: **277/288** empresas casadas em 2026; as ~53 que
  não casaram são, quase todas, empresas que não estão no painel (a própria planilha
  marca 37 como EXCLUÍDAS) ou as 4 recém-cadastradas.

## Alternativas consideradas
- **Automático (derivar das tarefas):** descartado por ora — depende de a equipe
  preencher as tarefas do contábil todo mês; a marcação manual é fiel ao hábito atual
  (poderá ser 2ª fase).
- **Manter no Excel:** descartado — sem visão ao vivo, arquivo trava/perde.

## Consequências técnicas
- Só `index.html`: nova view `contabanual` (painel `#painel-contabanual` + CSS),
  botão no menu, rota em `trocarView`, `loadContabAnual/saveContabAnual`,
  `renderContabAnual/renderCaTable`, `caToggle/caObs/caSetAno/caBusca/caSoPend/caResp`;
  chave `SK_CONTAB_ANUAL='ccc_contab_anual_v1'`; sincronização em tempo real da nova
  chave (recarga seletiva, seguindo ADR-0025). Sem `?v` (não mexeu em config/backend).
- Importação por scripts REST (auth gestora, dedup/casamento por CNPJ) — dado gravado
  na chave nova, **sem tocar** em tarefas/empresas.
- Verificado: sintaxe; render e interações no navegador (toggle, filtros, troca de
  ano, totais); sem erros de JS.

## Impacto operacional (no escritório)
- O contábil passa a ver e marcar, ao vivo e compartilhado, quais meses/anuais de cada
  empresa já foram feitos — substitui os Excels de controle.

## Benefício esperado
- ✅ **Qualidade/visão:** panorama imediato do ano (o que falta, por mês e por empresa).
- 🛡️ **Menos erro/perda:** fim do arquivo travando/sumindo na rede.
- ⏱️ **Tempo:** um clique marca; filtros acham pendências na hora.
