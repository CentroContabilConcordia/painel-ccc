# ADR-0015 — Origem do extrato em cada banco (Acesso × Cliente envia)

- **Data:** 2026-07-13
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Nem todo extrato bancário chega do mesmo jeito: em alguns bancos **o escritório
acessa e baixa sozinho**; em outros **o cliente é quem envia**. Sem essa distinção,
não dava para saber o que a equipe resolve sozinha e o que precisa **cobrar do
cliente** — ligado à dor do atraso de documentos (D1).

## Decisão
Cada banco (na aba **Bancos → Extratos**) ganhou o campo **"Origem do extrato"**,
fixo por banco, com duas opções:
- 🔑 **Acesso** — o escritório entra no banco e baixa.
- 📩 **Cliente envia** — depende do cliente mandar.

Aparece como um **seletor com selo** em cada banco e no formulário de
adicionar/editar. **Toda a equipe pode definir/alterar** (igual aos demais dados do
banco). Bancos ainda sem definição mostram "❓ Origem?".

## Consequências técnicas
- `index.html`: campo `origem` no objeto do banco (`bancosCad[emp][].origem`,
  valores `acesso`/`cliente`/vazio); seletor em `renderBancos`, leitura em
  `adicionarBanco`/`editarBanco`, e `mudarOrigemBanco()` para troca inline.
- Persistido no mesmo `empresas.bancos` (jsonb) — **sem mudança em
  `backend-supabase.js`/`config.js`** (sem bump de `?v`).

## Impacto operacional (no escritório)
- A equipe enxerga na hora quais extratos ela mesma baixa e quais precisa cobrar do
  cliente — base para futuros alertas/cobrança automática.

## Benefício esperado
- ⏱️ **Tempo:** não perde tempo cobrando cliente de banco que o escritório acessa.
- ✅ **Qualidade:** clareza de quem é responsável por cada extrato.
