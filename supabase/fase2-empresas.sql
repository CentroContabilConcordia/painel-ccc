-- ============================================================
-- Painel CCC — Fase 2 do isolamento (ADR-0002)
-- Cria a tabela de EMPRESAS (lista + ficha + dono fiscal) com as
-- regras de visibilidade. NÃO muda o app ainda — só prepara a estrutura.
-- Rode no SQL Editor do Supabase (cole tudo e Run).
-- ============================================================

-- Função de apoio: qual o setor da pessoa logada (roda "por dentro")
create or replace function public.meu_setor()
returns text language sql stable security definer set search_path = public as $$
  select setor from public.profiles where id = auth.uid()
$$;

-- Tabela de empresas: uma linha por empresa (nome + responsável fiscal + ficha)
create table if not exists public.empresas (
  id           bigint generated always as identity primary key,
  nome         text not null unique,
  fiscal_owner text,                       -- 'cris' | 'cleo' | 'julia' | 'gab' | null
  ficha        jsonb not null default '{}'::jsonb,
  created_at   timestamptz default now()
);

alter table public.empresas enable row level security;

-- VER: gestora vê todas; cada fiscal vê só as suas; contábil vê todas (setor aberto)
drop policy if exists "ver empresas" on public.empresas;
create policy "ver empresas" on public.empresas for select to authenticated
using (
  public.is_gestora()
  or fiscal_owner = public.meu_member_id()
  or public.meu_setor() = 'contabil'
);

-- EDITAR/CRIAR/EXCLUIR: por enquanto, só gestora
drop policy if exists "gerir empresas" on public.empresas;
create policy "gerir empresas" on public.empresas for all to authenticated
using ( public.is_gestora() )
with check ( public.is_gestora() );
