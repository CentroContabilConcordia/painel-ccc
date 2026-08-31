-- ============================================================
-- Painel CCC — Storage de imagens (Processos Questor + Observações
-- da ficha). Ver ADR-0022.
--
-- PASSO 1 (no painel do Supabase): Storage -> New bucket
--   Nome: imagens
--   Public bucket: LIGADO (ON)
--   -> Create bucket
--
-- PASSO 2: cole este SQL no SQL Editor e clique em Run.
--   (Libera o UPLOAD para usuárias logadas; a LEITURA já é pública
--    porque o bucket é público.)
-- ============================================================

create policy "imagens upload autenticado"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'imagens');

create policy "imagens update autenticado"
  on storage.objects for update to authenticated
  using (bucket_id = 'imagens') with check (bucket_id = 'imagens');

create policy "imagens delete autenticado"
  on storage.objects for delete to authenticated
  using (bucket_id = 'imagens');
