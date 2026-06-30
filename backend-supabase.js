// ============================================================
// Adaptador Supabase — implementa o contrato window.Backend.
//
// O APP NUNCA fala com o Supabase diretamente: ele fala com
// window.Backend / window.storage. Este e o UNICO arquivo que
// conhece o Supabase. Para migrar para outro PostgreSQL, crie um
// "backend-xxxx.js" que implemente as MESMAS funcoes e troque a
// linha <script> no index.html. Ver docs/ARQUITETURA.md.
// ============================================================
(function () {
  const cfg = (window.APP_CONFIG && window.APP_CONFIG.supabase) || {};
  const _sb = window.supabase.createClient(cfg.url, cfg.key);
  window._sb = _sb; // exposto so para diagnostico

  const PREFIX  = cfg.senhaPrefix  || 'cccp_';
  const DOMINIO = cfg.dominioEmail || '@cccpainel.app';
  const emailDoPerfil = (id) => id + DOMINIO;

  // Protecao anti-travamento: se o banco demorar demais, desiste
  // (a camada de cima cai na copia local em vez de travar).
  function _withTimeout(promise, ms, label) {
    return Promise.race([
      promise,
      new Promise((_, rej) => setTimeout(() => rej(new Error('tempo esgotado: ' + label)), ms))
    ]);
  }

  // -------- Armazenamento (chave/valor) --------
  async function get(key) {
    return _withTimeout((async () => {
      const { data, error } = await _sb.from('kv_store').select('value').eq('key', key).maybeSingle();
      if (error) throw error;
      if (data) return { value: data.value };
      // Migracao automatica: se nao ha no banco mas existe no navegador, sobe pro banco.
      const local = localStorage.getItem(key);
      if (local != null) {
        try { await _sb.from('kv_store').upsert({ key, value: local }, { onConflict: 'key' }); } catch (e) {}
        return { value: local };
      }
      return null;
    })(), 8000, 'ler ' + key);
  }
  async function set(key, value) {
    try { localStorage.setItem(key, value); } catch (e) {} // copia local imediata
    return _withTimeout((async () => {
      const { error } = await _sb.from('kv_store').upsert({ key, value }, { onConflict: 'key' });
      if (error) throw error;
      return true;
    })(), 8000, 'gravar ' + key);
  }

  // -------- Sincronizacao em tempo real --------
  let _remoteCb = null, _rtLigado = false;
  function _ligarRealtime() {
    if (_rtLigado) return; _rtLigado = true;
    _sb.channel('kv_store_changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'kv_store' }, () => {
        if (_remoteCb) { try { _remoteCb(); } catch (e) { console.warn('[CCC] onRemoteChange erro', e); } }
      })
      .subscribe();
  }
  _sb.auth.onAuthStateChange((event, session) => { if (session) _ligarRealtime(); });
  _sb.auth.getSession().then(({ data }) => { if (data && data.session) _ligarRealtime(); });

  // ============================================================
  // CONTRATO window.Backend (o que qualquer adaptador deve ter):
  //   signIn(perfilId, pin) -> { ok:true } | { ok:false, error }
  //   signOut()             -> Promise<void>
  //   onRemoteChange(cb)    -> registra callback p/ mudancas remotas
  //   get(key)              -> { value:string } | null
  //   set(key, value)       -> true
  // ============================================================
  window.Backend = {
    nome: 'supabase',
    async signIn(perfilId, pin) {
      try {
        const { error } = await _sb.auth.signInWithPassword({
          email: emailDoPerfil(perfilId),
          password: PREFIX + pin
        });
        return error ? { ok: false, error: error.message } : { ok: true };
      } catch (e) {
        return { ok: false, error: String(e && e.message || e) };
      }
    },
    async signOut() { try { await _sb.auth.signOut(); } catch (e) {} },
    onRemoteChange(cb) { _remoteCb = cb; },
    get,
    set,

    // -------- Empresas (tabela relacional; a RLS já entrega só o que o usuário pode ver) --------
    async getEmpresas() {
      const { data, error } = await _sb.from('empresas').select('nome,fiscal_owner,ficha').order('nome');
      if (error) throw error;
      return data || [];
    },
    async saveFicha(nome, ficha) {
      const { error } = await _sb.from('empresas').update({ ficha }).eq('nome', nome);
      if (error) throw error;
      return true;
    },
    async addEmpresa(nome, fiscal_owner, ficha) {
      const { error } = await _sb.from('empresas').insert({ nome, fiscal_owner: fiscal_owner || null, ficha: ficha || {} });
      if (error) throw error;
      return true;
    },
    async removeEmpresa(nome) {
      const { error } = await _sb.from('empresas').delete().eq('nome', nome);
      if (error) throw error;
      return true;
    }
  };

  // Compatibilidade: o app ja usa window.storage.get/set
  window.storage = { get, set };
})();
