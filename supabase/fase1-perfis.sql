-- ============================================================
-- Painel CCC — Fase 1 do isolamento (ADR-0002)
-- Cria a "lista de quem é quem" (perfis) e liga às 9 contas.
-- Rode no SQL Editor do Supabase (cole tudo e Run).
-- (Não muda nada no app ainda — só prepara a base.)
-- ============================================================

-- 1) Tabela de perfis: liga cada conta de login a uma pessoa/papel
create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  member_id  text not null,                 -- 'cris', 'cleo', ...
  nome       text not null,
  role       text not null default 'equipe',-- 'gestora' | 'equipe'
  setor      text,                           -- 'fiscal' | 'contabil' | null
  created_at timestamptz default now()
);

-- 2) Funções de apoio (rodam "por dentro", sem recursão de segurança)
create or replace function public.is_gestora()
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce((select role = 'gestora' from public.profiles where id = auth.uid()), false)
$$;

create or replace function public.meu_member_id()
returns text language sql stable security definer set search_path = public as $$
  select member_id from public.profiles where id = auth.uid()
$$;

-- 3) Segurança da própria tabela de perfis: cada um lê o seu; gestora lê todos
alter table public.profiles enable row level security;
drop policy if exists "ler perfis" on public.profiles;
create policy "ler perfis" on public.profiles for select to authenticated
  using ( id = auth.uid() or public.is_gestora() );

-- 4) Preenche os 9 perfis (liga e-mail -> conta -> pessoa)
insert into public.profiles (id, member_id, nome, role, setor)
select u.id, x.member_id, x.nome, x.role, x.setor
from (values
  ('patty@cccpainel.app','patty','Patty',    'gestora', null),
  ('diane@cccpainel.app','diane','Diane',    'gestora', null),
  ('cris@cccpainel.app', 'cris', 'Cristiane','equipe',  'fiscal'),
  ('cleo@cccpainel.app', 'cleo', 'Cleonice', 'equipe',  'fiscal'),
  ('julia@cccpainel.app','julia','Julia',    'equipe',  'fiscal'),
  ('gab@cccpainel.app',  'gab',  'Gabriela', 'equipe',  'fiscal'),
  ('carla@cccpainel.app','carla','Carla',    'equipe',  'contabil'),
  ('neusa@cccpainel.app','neusa','Neusa',    'equipe',  'contabil'),
  ('marli@cccpainel.app','marli','Marli',    'equipe',  'contabil')
) as x(email, member_id, nome, role, setor)
join auth.users u on u.email = x.email
on conflict (id) do update
  set member_id = excluded.member_id, nome = excluded.nome,
      role = excluded.role, setor = excluded.setor;
