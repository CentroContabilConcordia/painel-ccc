# ADR-0006 — "Continuar conectada" (sessão persistente)

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A equipe precisava escolher perfil + digitar o PIN **toda vez** que a página
recarregava (incluindo depois de cada atualização do app). A equipe usa, na
maioria, **aparelhos pessoais** (celular/PC próprio).

## Decisão
Ativar **"continuar conectada"**: se já houver uma sessão válida do Supabase, o
app **entra direto** (sem pedir login de novo). O botão **"Sair"** encerra a
sessão (aí o próximo acesso pede login). Escolha baseada no uso em aparelhos
pessoais (em PC compartilhado seria menos seguro).

## Consequências técnicas
- `backend-supabase.js`: novo `Backend.currentUser()` (id do perfil da sessão ou null).
- `index.html`: no `DOMContentLoaded`, se `currentUser()` retornar um perfil válido,
  entra direto (esconde login, chama `iniciarApp`).
- **Atualizações ficam invisíveis** — ninguém é jogado para a tela de login ao
  recarregar.

## Impacto operacional (no escritório)
- A equipe loga **uma vez** e permanece dentro; atualizações não atrapalham.

## Benefício esperado
- ⏱️ **Tempo:** menos passos no dia a dia.
- ✅ **Qualidade:** atualizações sem fricção.
- 🛡️ **Risco:** baixo em aparelho pessoal. Em PC **compartilhado** não seria
  recomendado (quem sentar entraria na conta anterior) — por isso a decisão
  dependeu do uso ser pessoal.
