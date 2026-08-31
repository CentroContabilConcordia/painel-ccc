# ADR-0022 — Imagens nos Processos e nas Observações (Supabase Storage)

- **Data:** 2026-08-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A Patrícia pediu para **anexar imagens**: (1) nos **Processos Questor** (prints do
passo a passo) e (2) nas **Observações e Particularidades** da ficha da empresa
(visualizar as particularidades mais fácil).

## Decisão
- **Armazenamento: Supabase Storage** (escolha da Patrícia entre Storage × base64),
  bucket **público** `imagens`. O app guarda só a **URL** da imagem nos dados —
  leve, não incha os blobs (importante porque as fichas carregam todas juntas).
- **Upload no cliente:** a imagem é **comprimida/redimensionada** (máx. 1500px, JPEG
  ~0,72) antes de subir, via `window._sb.storage.from('imagens')`. A leitura usa a
  URL pública.
- **Processos:** cada processo tem `imagens: [url]`; botão "📷 Adicionar imagem" no
  formulário; miniaturas na lista (clique abre em tamanho grande).
- **Observações da ficha:** cada observação tem `imagens: [url]`; dá para anexar
  imagem a uma observação existente (📷) ou à "próxima observação" antes de criá-la;
  miniaturas exibidas com a observação; remover imagem individual.

## Consequências técnicas
- `index.html`: `comprimirImagem`/`uploadImagem`; UI e funções em Processos
  (`anexarImgProc`/`renderProcImgs`) e em Observações (`anexarImgObs`,
  `anexarImgNova`, `renderObsNovaImgs`, `removerImgObs`); `adicionarObs` guarda
  `imagens`. Só `index.html`.
- **Setup único no Supabase (Patrícia):** criar bucket público `imagens` +
  `supabase/storage-imagens.sql` (policies de upload p/ autenticadas). Sem esse
  setup, o upload falha com aviso na tela.
- Verificado no navegador: render das miniaturas (lista e formulário) e funções OK;
  upload real depende do bucket criado.

## Impacto operacional
- Manual de processos com prints; particularidades da empresa com imagens — muito
  mais fácil de entender e executar.

## Benefício esperado
- ✅ **Qualidade/clareza:** processos e particularidades ilustrados.
- ⏱️ **Tempo:** menos dúvida sobre "como é" na tela do Questor.
