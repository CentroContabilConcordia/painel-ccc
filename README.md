# Painel CCC — Centro Contábil Concórdia

Painel de gestão de tarefas fiscais e contábeis da equipe, com dados
**compartilhados em tempo real** entre todos os membros.

## Tecnologia
- **Frontend:** HTML/CSS/JS em arquivo único (`index.html`)
- **Backend:** Supabase (Postgres + Auth + Realtime)
- **Hospedagem:** GitHub Pages

## Estrutura
- `index.html` — o aplicativo (é o que fica publicado)
- `supabase/` — scripts SQL do banco (estrutura + regras de segurança)
- `docs/` — plano e documentação do projeto
- `original/` — backup da versão original (intocada)
- `tools/teste-conexao.html` — página de diagnóstico da conexão com o banco

## Acesso
Cada membro entra com seu **perfil + PIN**. As contas e senhas são
gerenciadas com segurança no Supabase Auth (não há senhas no código).
