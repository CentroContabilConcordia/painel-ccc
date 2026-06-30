# 📘 CCC Master Plan — a "bíblia" do sistema

> **Lema do projeto:** *"Isso economiza tempo ou melhora a qualidade do trabalho da equipe?"*
> Toda decisão passa por aqui. Se a resposta for "não", não entra.

> Documento vivo. Versão **0.1** — _criado em 26/06/2026_. Itens `[A DEFINIR]` precisam da equipe.

---

## 0. Como trabalhamos (disciplina de produto)

Isto é um **produto de software**, não um experimento. Para cada nova ideia, perguntamos:

1. **Resolve um problema real?**
2. **Vale a pena implementar agora?** (ou é distração?)
3. **Como impacta os outros módulos?**
4. **Há uma forma mais simples de chegar ao mesmo resultado?**

Princípios de engenharia que já adotamos e vamos manter:
- **Dados de cliente nunca no código** — só no banco protegido, carregados após login.
- **App desacoplado do fornecedor** — o app fala com `window.Backend`; o Supabase é peça trocável. (ver `ARQUITETURA.md`)
- **Gerenciado-primeiro** — preferimos serviços gerenciados (Supabase) a manter servidores, enquanto não houver necessidade concreta.
- **Simples antes de sofisticado** — só adicionamos complexidade (frameworks, servidores) quando um passo concreto exigir.

### Governança (como decidimos)

- **Decisões de NEGÓCIO** (módulos, fluxos, prioridades, regras) → definidas por **entrevista com a Patrícia**.
- **Decisões de ARQUITETURA/TÉCNICA** → **eu (Claude) proponho**, mas **NADA é implementado sem revisão e aprovação antes**.
  - Cada decisão técnica relevante vira uma **Proposta** curta, em português claro: o que, por quê, alternativas, impacto nos outros módulos e recomendação.
  - Só codifico depois de um **"aprovado"** explícito.
  - Objetivo permanente: o sistema deve permanecer **modular, desacoplado e preparado para evoluir ao longo dos anos**.
- **Registro de decisões:** cada decisão aprovada vira uma ficha em [`docs/decisoes/`](decisoes/), documentando obrigatoriamente: **contexto, decisão, impacto operacional no escritório, quem aprovou e o benefício esperado** (⏱️ tempo · ✅ qualidade · 🛡️ menos erros). Assim as escolhas fazem sentido daqui a anos e cada decisão "prova seu valor".

---

## 1. Missão  ✅ _confirmada com a Patrícia (29/06/2026)_

> Centralizar e organizar o trabalho do Centro Contábil Concórdia — fiscal, contábil, RH e BPO — num único sistema que **economiza tempo da equipe, reduz erros e dá visão clara do que precisa ser feito**, para a equipe e para o cliente.

## 2. Objetivos (do projeto)

- ⏱️ **Economizar tempo** da equipe (menos retrabalho, menos planilha solta).
- 🗂️ **Centralizar informações** (tarefas, empresas, fichas, documentos num lugar só).
- 🤖 **Automatizar processos** (apurações, lembretes, integrações, IA).
- 📊 **Apoiar decisões** (dashboards, indicadores).

### 🎯 Foco atual (próximos 60 dias) — _definido com a Patrícia (29/06/2026)_

**Controle operacional dos processos internos.** A dor nº1 hoje é controlar as
operações e as respostas, e o **retrabalho** que vem disso. Meta do período:
o sistema ser a **torre de controle** — ver o que precisa ser feito, por quem,
o que está parado/atrasado — para **reduzir retrabalho** e **alinhar/padronizar**
os processos da equipe. _(Beleza visual/celular fica para depois.)_

---

## 3. Estado atual (o que JÁ existe hoje)

| Item | Status |
|---|---|
| Painel de tarefas fiscais/contábeis (por membro/empresa/mês) | ✅ no ar |
| Fichas de empresa (CNPJ, regime, contatos) | ✅ |
| Login seguro por perfil + PIN (9 contas) | ✅ |
| Dados compartilhados em tempo real | ✅ |
| Dados de cliente fora do código (protegidos) | ✅ |
| Publicado: https://centrocontabilconcordia.github.io/painel-ccc/ | ✅ |
| Código versionado: github.com/CentroContabilConcordia/painel-ccc | ✅ |
| Isolamento de acesso (fiscal por pessoa; contábil aberto; gestoras tudo) — RLS no banco | ✅ (ADR-0002) |
| Senhas fortes (substituir PINs óbvios) | ⬜ próximo |
| Isolamento das TAREFAS por pessoa (hoje tarefas vazias) | ⬜ fase futura |
| Layout no celular (responsivo) | ⬜ adiado de propósito |

**Stack atual:** HTML/CSS/JS (1 arquivo) + Supabase (PostgreSQL + Auth + Realtime) + GitHub Pages.

---

## 4. Módulos (visão do produto)

| Módulo | O que faz | Status |
|---|---|---|
| **Fiscal** | Tarefas, apurações, obrigações por empresa/mês | ✅ base feita |
| **Contábil** | Tarefas e fechamentos contábeis | ✅ base feita |
| **RH** | Colaboradores, controle interno | 🟡 cadastro inicial |
| **BPO** | `[A DEFINIR]` escopo do BPO financeiro | ⬜ |
| **Portal do Cliente** | Cliente acessa documentos, status, certidões | ⬜ |
| **IA** | Assistente, automações inteligentes | ⬜ |
| **Reforma Tributária** | Apoio à transição (CBS/IBS) | ⬜ |
| **Dashboard** | Indicadores e visão gerencial | 🟡 relatórios básicos |
| **Documentos** | Guarda e organização de arquivos | ⬜ |
| **Agenda** | Prazos e obrigações com datas | ⬜ |
| **Certidões** | Emissão/controle de certidões | ⬜ |
| **Clientes** | Cadastro central de empresas/clientes | 🟡 lista + fichas |

> `[A DEFINIR]` Para cada módulo: 1 frase de "problema que resolve" + prioridade.

---

## 5. Decisão de fundação `[DECIDIR JUNTOS]`

**Pergunta:** backend gerenciado (Supabase) ou auto-hospedado (Node + PostgreSQL próprio)?

- **Recomendação:** gerenciado-primeiro. Manter Supabase (Postgres + Auth + Realtime) e usar **Edge Functions** para lógica de servidor/integrações. Adotar **Node.js + framework de front** quando o app crescer além de 1 arquivo.
- **Reavaliar auto-hospedagem** só se um requisito concreto exigir (custo, soberania de dados, integração específica).

➡️ **Status:** aguardando sua confirmação.

---

## 6. Banco de Dados

**Hoje:** uma tabela `kv_store (key, value JSON)` — simples e portável.

**Direção (quando crescer):** normalizar em tabelas reais, ex.:
`empresas`, `membros/usuarios`, `tarefas`, `competencias`, `fichas`, `contatos`,
`bancos`, `documentos`, `certidoes`, `prazos`, `clientes_portal` … `[A DETALHAR]`

> Regra: cada tabela e cada campo entram só quando um módulo precisar — não antes.

---

## 7. Fluxos

### 7.1 Fechamento mensal de uma empresa — ✅ mapeado (30/06/2026)

**Quem faz:** a responsável (fiscal) faz as **4 fases sozinha**, para cada empresa da
sua carteira. As **gestoras monitoram** (não aprovam etapa a etapa).

**Fases:**
1. **Documentos** — receber do cliente: extratos, XMLs, distribuição de lucros, pró-labore, plano de saúde.
2. **Fechamento** — conferir NF-e (entrada/saída), serviços tomados/prestados, importar XML, conferir CFOP/CST/NCM, encerrar o mês.
3. **Apuração** — apurar tributos (Simples/PGDAS, ICMS, PIS/COFINS, ISS, IRPJ/CSLL, retenções…) e emitir guias.
4. **Obrigações + Entrega** — SPED/declarações e entregar/avisar o cliente.

**Onde mais trava / gera retrabalho (as 4 dores — todas confirmadas):**
- 🔴 **D1 — Cliente atrasa os documentos** (Fase 1).
- 🔴 **D2 — Nota faltando → refaz a apuração** (dado incompleto).
- 🔴 **D3 — Erro de classificação (CFOP/CST/NCM) que só aparece no fim**.
- 🔴 **D4 — Esquecem de cobrar / fazer algo** (etapa esquecida).

**Como o sistema combate cada dor:**
| Dor | Solução no sistema |
|---|---|
| D1 atraso docs | Status "aguardando documento" + registro de quando foi cobrado; painel da gestora mostra quem está parado esperando cliente. |
| D2 nota faltando | Marcar "documentos conferidos" antes de liberar a Apuração — sinaliza se apurar com pendência. |
| D3 classificação | Checklist explícito de conferência (CFOP/CST/NCM) na Fase 2 — não dá pra "esquecer de conferir". |
| D4 esquecimento | Checklist padrão por empresa/mês (já existe) + alertas do que está parado/atrasado. |

**Base já pronta:** checklist padrão de tarefas por empresa/mês; status por tarefa
(pendente/andamento/aguardando/atrasado/concluído/N-A); barra de progresso %.

**A construir (prioridade a definir):** painel de monitoramento da gestora · status
"aguardando documento" + cobrança · alertas de atraso · trava de docs antes da apuração.

### 7.2 Outros fluxos — `[A MAPEAR DEPOIS]`
Entrada de cliente novo · Emissão de certidão · Atendimento via Portal do Cliente.

---

## 8. Integrações (futuras)

| Integração | Uso | Prioridade |
|---|---|---|
| **Questor** | Sistema contábil — importar/exportar dados | `[A DEFINIR]` |
| **WhatsApp** | Avisos/atendimento à equipe e clientes | `[A DEFINIR]` |
| **Google / Microsoft** | Login, agenda, arquivos | `[A DEFINIR]` |
| **Receita** | Certidões, situação fiscal | `[A DEFINIR]` |
| **Bancos** | Extratos, conciliação | `[A DEFINIR]` |

> Integrações são as partes mais sensíveis (segredos, segurança). Cada uma vira um mini-projeto próprio, no servidor (Edge Functions), nunca no app público.

---

## 9. Roadmap (versões)

- **Sprint 0 — Fundação (onde estamos):** ✅ Git · ✅ GitHub · ✅ VS Code · ✅ Python · ✅ Publicação · ⬜ Master Plan (este doc) · ⬜ decisão de fundação · ⬜ estrutura definitiva do projeto
- **Sprint 1 — Núcleo:** Login · Usuários · Empresas · Dashboard
- **Sprint 2 — Tarefas:** controle de tarefas completo
- **Sprint 3 — Portal do Cliente**
- **Sprint 4 — Reforma Tributária**

> **Versão 1** = Sprints 0–2 sólidos. **V2** = Portal. **V3** = IA/automações. **V4** = Reforma Tributária. `[AJUSTAR]`

---

## 10. Perguntas em aberto (para preencher juntos)

1. Missão — a frase da seção 1 te representa?
2. Decisão de fundação (seção 5) — seguimos gerenciado-primeiro?
3. Quais **3 módulos** trazem mais valor nos próximos 60 dias?
4. Qual **fluxo real** você quer que eu mapeie primeiro?
5. Alguma integração é **urgente** (ex.: Questor)?
