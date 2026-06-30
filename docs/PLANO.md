# Plano — Transformar o Painel CCC em app online para a equipe

## Objetivo
Hoje o painel é um arquivo `.html` onde cada pessoa vê só os dados do próprio navegador.
Meta: um app acessível por um **link na internet**, onde **toda a equipe vê e atualiza
as mesmas tarefas, em tempo real**, com login seguro.

## Arquitetura escolhida
- **Banco de dados + login + tempo real:** Supabase (plano gratuito é suficiente).
- **Frontend:** o próprio HTML atual, quase sem mudanças — o app já tem a camada
  `window.storage.get/set` que vamos "ligar" no Supabase.
- **Hospedagem do link:** Cloudflare Pages / Vercel / Netlify (gratuito) — definimos na Fase 4.
- **Código versionado:** GitHub (Fase 5 — primeiro PR).

## Estado de hoje (mapeado)
5 "gavetas" de dados que hoje ficam só no navegador e vão para o banco:
1. `ccc_v8` — tarefas e status por setor/membro/empresa/mês (+ status de bancos).
2. `ccc_fichas_v1` — fichas das empresas (CNPJ, CNAE, regime, contatos, observações). **Já tem dados reais.**
3. `ccc_empresas_v1` — empresas cadastradas manualmente.
4. `ccc_colab_v1` — colaboradores (RH).
5. `ccc_bancos_v1` — contas bancárias por empresa.

## Fases
- [x] **Fase 0 — Preparação** (sem precisar de conta): organizar o projeto, mapear os dados, escrever o esquema do banco. ✅
- [ ] **Fase 1 — Criar o banco**: criar projeto no Supabase e rodar o `schema.sql`. *(precisa de você: criar a conta)*
- [x] **Fase 2 — Ligar o app ao banco**: plugar `window.storage` no Supabase + sincronização em tempo real. ✅
  - Corrigido um bug de sintaxe que já vinha no arquivo original (aspas mal escapadas em `atualizarContato`, 4 ocorrências) e travava o app inteiro.
  - Verificado ponta a ponta: login → abrir empresa → marcar tarefa → salvou na nuvem → leu de volta. Canal de tempo real "joined".
- [x] **Fase 3 — Login seguro**: ✅ 9 contas reais no Supabase Auth; senhas removidas do código; login via signInWithPassword (perfil + PIN); RLS bloqueia anônimo; cadastro público desligado.
  - E-mail interno por perfil: `<id>@cccpainel.app`. Senha = PIN atual (prefixo interno `cccp_` só para atingir o mínimo do servidor — não é segredo).
  - Verificado: conta real entra/lê/grava; anônimo bloqueado.
  - Pendência futura: PINs são curtos — dá pra trocar por senhas mais fortes depois. Colaboradores do RH ainda guardam senha em texto (separado do login).
- [~] **Fase 4 — Publicar o link** (via GitHub Pages, escolha do usuário):
  - [x] **Proteção de dados (essencial antes de publicar):** lista de empresas, fichas (CNPJ) e contatos foram REMOVIDAS do arquivo e movidas para o banco protegido (chaves `ccc_ref_v1` e `ccc_fichas_v1`). A página pública não contém nenhum dado de cliente — só carrega após login. Verificado.
  - [x] Projeto reorganizado (`index.html` na raiz) + README + .gitignore (exclui `original/`).
  - [x] **Arquitetura portável (anti-lock-in):** app desacoplado do Supabase. Fala só com `window.Backend`/`window.storage`. Supabase isolado em `backend-supabase.js`; config em `config.js`; contrato documentado em `docs/ARQUITETURA.md`. Para migrar a outro PostgreSQL, basta um novo `backend-*.js`. Verificado.
  - [x] Subir para o GitHub e ligar o GitHub Pages. ✅ **No ar:** https://centrocontabilconcordia.github.io/painel-ccc/
- [x] **Fase 5 — GitHub**: ✅ código versionado em https://github.com/CentroContabilConcordia/painel-ccc
  - (Opcional) Fazer uma melhoria pequena via Pull Request, para experimentar o fluxo de PR.

## Limitações conhecidas (a melhorar depois)
- **Concorrência:** a v1 grava a "gaveta" inteira de uma vez (igual hoje). Se duas pessoas
  salvarem no mesmo segundo, uma pode sobrescrever a outra. Para uma equipe pequena é
  aceitável; depois dá pra evoluir para gravação por registro.
- **Senhas curtas (PIN):** mantemos o PIN por praticidade, mas agora ele fica protegido no
  servidor (com limite de tentativas), não mais visível no código.
