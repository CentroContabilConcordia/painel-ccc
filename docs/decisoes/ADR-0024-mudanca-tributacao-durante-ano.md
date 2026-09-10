# ADR-0024 — Mudança de tributação durante o ano (histórico de regime)

- **Data:** 2026-09-10
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Empresas podem **mudar de regime tributário no meio do ano** (ex.: HIDRO REABILITAR
passou de **Simples Nacional** para **Lucro Presumido a partir de 01/08/2026**). O
painel só guardava **um** regime na ficha, e as tarefas da aba Tarefas herdavam o
"não se aplica" do mês anterior — o que, numa virada de regime, ficava errado (as
tarefas do regime antigo continuavam marcadas como N/A no regime novo).

Era preciso: (a) registrar a mudança com a **data**, (b) **manter o regime anterior
e o período**, (c) refletir na **ficha** E na **aba Tarefas** (as tarefas passam a
ser as do novo regime a partir do mês da virada).

## Decisão
Criado o **Histórico de tributação** (linha do tempo) na ficha:

- `ficha.regimeHist` = lista de segmentos `{regime, desde:'AAAA-MM' (''=desde sempre),
  anexos:[]}`. Empresas que nunca mudaram **não** ganham nada (a lista fica vazia e o
  sistema usa o `ficha.regime` atual como antes).
- Botão **"+ Registrar mudança de tributação"**: escolhe o **novo regime** (qualquer um
  dos 5), a **competência de início** (mês/ano) e, se for Simples, os anexos. Ao
  confirmar: o regime que estava vira o **segmento anterior com período fechado**, o
  novo vira o **atual**, e `ficha.regime`/`ficha.anexos` passam a ser o do último
  segmento (compatibilidade com relatórios e filtros).
- A linha do tempo aparece na seção **Regime Tributário**, mostrando cada regime com
  seu período (ex.: *Simples Nacional (Anexo III) — desde o início até Julho/2026* /
  *Lucro Presumido — a partir de Agosto/2026 · atual*), com ✕ para corrigir/excluir um
  registro. Editar o campo "Regime" normal passa a editar o **segmento atual**.
- **Aba Tarefas:** cada mês mostra um selo **"Regime deste mês: …"** (só para empresas
  com mudança). No **mês da virada**, as tarefas **não herdam** o "não se aplica" do
  regime antigo — começam limpas; a equipe marca uma vez o que se aplica ao novo
  regime, e os meses seguintes voltam a herdar normalmente.

## Alternativas consideradas
- **Marcar as tarefas automaticamente por regime** (mapear cada tarefa a cada regime):
  descartada — menos preciso e frágil; dependeria de manter um mapa tarefa×regime que
  pode não bater com o processo real do escritório.
- **Deixar como estava** (um regime só): descartada — não representa a realidade e
  contamina as tarefas do mês de virada.

## Consequências técnicas
- `index.html` apenas. Novos helpers: `regimeSegmentos`, `regimeVigenteMes`,
  `ehMesDeVirada`, `_mesAnteriorKey`, `regimeHistHTML`; funções de fluxo
  `abrirMudancaRegime`/`mrToggleAnexo`/`confirmarMudancaRegime`/`excluirMudancaRegime`;
  novo modal `#modal-regime`; selo do regime em `renderTarefas`; `novasTarefasMes`
  não herda N/A no mês de virada; `salvarFicha` sincroniza o segmento atual.
- Compatível com o que já existe: sem histórico, tudo funciona como antes. Nenhum
  dado real é apagado. Verificado no navegador (lógica dos meses, não-herança na
  virada, herança normal nos demais meses, construção/edição/exclusão do histórico,
  modal e linha do tempo).

## Impacto operacional (no escritório)
- A gestora registra a virada uma vez; a equipe passa a ver, mês a mês, **pelo qual
  regime se guiar**, e as tarefas do mês da mudança já vêm limpas para o novo regime.
- O histórico do regime anterior fica preservado (auditoria/consulta).

## Benefício esperado
- ✅ **Qualidade:** ficha e tarefas refletem a tributação real de cada mês.
- 🛡️ **Redução de erros:** acaba a contaminação do "não se aplica" antigo na virada.
- ⏱️ **Tempo:** sem retrabalho manual para "consertar" as tarefas após uma mudança.
