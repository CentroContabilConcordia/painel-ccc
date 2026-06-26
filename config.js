// ============================================================
// Configuracao de conexao do Painel CCC
//
// Aqui ficam SO as configuracoes (nao o codigo). Para trocar de
// backend no futuro (ex.: outro PostgreSQL), mude "backend" e
// carregue o adaptador correspondente no index.html.
// Ver docs/ARQUITETURA.md.
// ============================================================
window.APP_CONFIG = {
  // Qual adaptador esta ativo. Hoje: 'supabase'.
  backend: 'supabase',

  // Configuracoes do adaptador Supabase (backend-supabase.js).
  // A chave abaixo e a "publishable/anon" — feita para ficar no app
  // e protegida pelas regras de seguranca (RLS) do banco.
  supabase: {
    url: 'https://wpjqkhwmqedqvsmzbjzd.supabase.co',
    key: 'sb_publishable_Uci-SdIZchMNiml3WBsu9A_0F7mbwso',
    senhaPrefix: 'cccp_',          // prefixo interno p/ tamanho minimo de senha (nao e segredo)
    dominioEmail: '@cccpainel.app' // dominio dos e-mails internos de login
  }
};
