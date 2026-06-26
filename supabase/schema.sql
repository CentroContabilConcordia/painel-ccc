-- ============================================================
-- Painel CCC — Esquema do banco de dados (Supabase / PostgreSQL)
-- Versão 1: armazenamento compartilhado em "chave/valor"
--
-- Como usar: no painel do Supabase, abra "SQL Editor",
-- cole TODO este arquivo e clique em "Run".
-- ============================================================

-- Tabela única que espelha as 5 "chaves" que hoje ficam no navegador
-- (ccc_v8, ccc_fichas_v1, ccc_empresas_v1, ccc_colab_v1, ccc_bancos_v1).
-- Cada chave vira uma linha; o conteúdo é guardado como texto JSON,
-- exatamente no formato que o app já usa hoje.
create table if not exists public.kv_store (
  key        text primary key,
  value      text not null,
  updated_at timestamptz not null default now()
);

-- Atualiza updated_at automaticamente a cada gravação
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_kv_touch on public.kv_store;
create trigger trg_kv_touch
  before update on public.kv_store
  for each row execute function public.touch_updated_at();

-- ------------------------------------------------------------
-- Sincronização em tempo real: quando alguém grava, os outros
-- navegadores recebem o aviso e atualizam a tela na hora.
-- ------------------------------------------------------------
alter publication supabase_realtime add table public.kv_store;

-- ------------------------------------------------------------
-- Segurança (RLS): somente usuários LOGADOS podem ler/gravar.
-- Sem login válido, a API não devolve nenhum dado dos clientes.
-- ------------------------------------------------------------
alter table public.kv_store enable row level security;

drop policy if exists "ler dados (logado)"     on public.kv_store;
drop policy if exists "inserir dados (logado)" on public.kv_store;
drop policy if exists "atualizar dados (logado)" on public.kv_store;

create policy "ler dados (logado)"
  on public.kv_store for select
  to authenticated using (true);

create policy "inserir dados (logado)"
  on public.kv_store for insert
  to authenticated with check (true);

create policy "atualizar dados (logado)"
  on public.kv_store for update
  to authenticated using (true) with check (true);
