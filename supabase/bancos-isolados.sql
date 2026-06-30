-- ============================================================
-- Painel CCC — Bancos isolados por empresa
-- Adiciona uma "gaveta" de bancos dentro da tabela empresas
-- (assim os bancos herdam o mesmo isolamento das fichas).
-- A regra de UPDATE (ADR-0005) já deixa a equipe salvar nas
-- empresas que ela vê — então não precisa de mais nada.
-- Rode no SQL Editor do Supabase (cole e Run).
-- ============================================================

alter table public.empresas
  add column if not exists bancos jsonb not null default '[]'::jsonb;
