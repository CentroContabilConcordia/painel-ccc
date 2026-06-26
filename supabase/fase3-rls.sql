-- ============================================================
-- Painel CCC — Fase 3: trancar o acesso a contas REAIS
-- Bloqueia o acesso anonimo aos dados (so as 9 contas entram).
-- Rode no SQL Editor do Supabase (cole tudo e Run).
-- ============================================================

drop policy if exists "ler dados (logado)"       on public.kv_store;
drop policy if exists "inserir dados (logado)"   on public.kv_store;
drop policy if exists "atualizar dados (logado)" on public.kv_store;
drop policy if exists "ler dados (conta real)"       on public.kv_store;
drop policy if exists "inserir dados (conta real)"   on public.kv_store;
drop policy if exists "atualizar dados (conta real)" on public.kv_store;

-- So permite quem esta logado E nao e sessao anonima
create policy "ler dados (conta real)"
  on public.kv_store for select
  to authenticated
  using ( coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false) = false );

create policy "inserir dados (conta real)"
  on public.kv_store for insert
  to authenticated
  with check ( coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false) = false );

create policy "atualizar dados (conta real)"
  on public.kv_store for update
  to authenticated
  using ( coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false) = false )
  with check ( coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false) = false );
