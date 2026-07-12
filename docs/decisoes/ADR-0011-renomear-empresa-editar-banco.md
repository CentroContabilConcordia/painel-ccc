# ADR-0011 — Renomear empresa + Editar banco

- **Data:** 2026-07-04
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
A equipe precisava (1) **corrigir/atualizar o nome** de uma empresa e (2) **editar**
os dados de um banco já cadastrado (nome/agência/conta) — antes só dava para
adicionar ou remover.

## Decisão
- **Renomear empresa:** botão **"✏️ Renomear"** na ficha (**só gestora**, como os
  demais dados cadastrais). Renomeia na tabela `empresas` **e migra junto as
  tarefas** (que são chaveadas pelo nome da empresa em `ccc_v8`), para **não perder
  histórico**. Bloqueia se já existir empresa com o novo nome.
- **Editar banco:** botão **✎** em cada banco. Reaproveita o formulário de
  adicionar em "modo edição" (`_bancoEditando`): preenche os campos, e ao salvar
  atualiza o banco em vez de criar um novo. A equipe pode (igual adicionar/remover).

## Consequências técnicas
- `backend-supabase.js`: novo `Backend.renameEmpresa(oldNome, novoNome)`.
- `index.html`: `renomearEmpresa()` (renomeia + migra chaves de `db` + `saveDB` +
  `loadRef`); `editarBanco()` + `_bancoEditando`; `adicionarBanco()` trata edição;
  `renderBancos()` limpa a edição a cada render e mostra o botão ✎.
- Verificado no navegador com empresas de teste (renomeou + migrou tarefas; editou
  banco e persistiu) — dados reais intactos.

## Impacto operacional (no escritório)
- Corrigir nome de empresa e ajustar dados bancários direto no sistema, sem
  depender de suporte técnico.

## Benefício esperado
- ⏱️ **Tempo:** correções na hora.
- ✅ **Qualidade:** dados sempre certos, sem perder histórico ao renomear.
