-- ============================================================
-- Painel CCC — Permitir que a EQUIPE edite a ficha das empresas
-- que ela já vê (para poder adicionar Observações).
-- Inserir/excluir empresa continua só para gestora.
-- Rode no SQL Editor do Supabase (cole tudo e Run).
-- ============================================================

drop policy if exists "gerir empresas" on public.empresas;

-- Criar empresa: só gestora
create policy "inserir empresas" on public.empresas for insert
  to authenticated with check ( public.is_gestora() );

-- Excluir empresa: só gestora
create policy "excluir empresas" on public.empresas for delete
  to authenticated using ( public.is_gestora() );

-- Atualizar (salvar ficha/observações): quem já pode VER a empresa
--   gestora (todas) | fiscal dona da empresa | qualquer um do contábil
create policy "atualizar empresas" on public.empresas for update
  to authenticated
  using ( public.is_gestora() or fiscal_owner = public.meu_member_id() or public.meu_setor() = 'contabil' )
  with check ( public.is_gestora() or fiscal_owner = public.meu_member_id() or public.meu_setor() = 'contabil' );
