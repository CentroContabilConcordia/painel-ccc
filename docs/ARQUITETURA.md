# Arquitetura — separação App ↔ Backend

## Princípios (manter no longo prazo)

1. **Dados de clientes NUNCA ficam no código.** A lista de empresas, fichas
   (CNPJ), contatos e tarefas vivem apenas no banco protegido e só carregam
   **após o login**. O `index.html` publicado não contém nenhum dado de cliente.
2. **O app não conhece o fornecedor.** O `index.html` fala apenas com uma
   interface genérica (`window.Backend` / `window.storage`). O Supabase é só
   o **adaptador atual** — trocável sem reescrever o app.

## Peças

| Arquivo | Papel |
|---|---|
| `index.html` | O aplicativo. Usa **só** `window.Backend` e `window.storage`. Não tem código de Supabase. |
| `config.js` | Configurações de conexão (qual backend + suas chaves). |
| `backend-supabase.js` | **Adaptador** Supabase. Único arquivo que conhece o Supabase. |
| `supabase/*.sql` | Estrutura do banco (tabela `kv_store`) e regras de segurança (RLS). |

## O contrato `window.Backend`

Qualquer adaptador (hoje Supabase; amanhã outro PostgreSQL) deve oferecer:

```js
window.Backend = {
  nome: 'supabase',                       // identificador do adaptador
  async signIn(perfilId, pin),            // -> { ok:true } | { ok:false, error }
  async signOut(),                        // -> Promise<void>
  onRemoteChange(callback),               // chama callback quando outro cliente grava
  async get(key),                         // -> { value:string } | null
  async set(key, value)                   // -> true
};
window.storage = { get, set };            // atalho de dados usado pelo app
```

### Modelo de dados (portável)
Tudo é guardado como **chave → valor (texto JSON)** numa única tabela
`kv_store(key text primary key, value text)`. Isso é PostgreSQL puro —
funciona em qualquer Postgres, não só no Supabase. Chaves usadas:

- `ccc_v8` — tarefas/status por setor/membro/empresa/mês
- `ccc_fichas_v1` — fichas das empresas (CNPJ, contatos…)
- `ccc_ref_v1` — lista de empresas por membro + lista geral
- `ccc_empresas_v1`, `ccc_colab_v1`, `ccc_bancos_v1` — cadastros auxiliares

## Como migrar para outro PostgreSQL (no futuro)

1. Suba a tabela `kv_store` (mesmo SQL de `supabase/schema.sql`) no novo Postgres.
2. Tenha uma forma de **autenticação** e uma **API** (ex.: PostgREST, ou um
   pequeno servidor) que respeite as regras de acesso.
3. Crie `backend-novo.js` implementando o **mesmo contrato** acima.
4. Em `index.html`, troque `<script src="backend-supabase.js">` por
   `<script src="backend-novo.js">` e ajuste o `config.js`.
5. Copie os dados (basta exportar/importar as linhas de `kv_store`).

O `index.html` **não muda** — essa é a razão de existir desta separação.

## Sincronização
O adaptador avisa o app de mudanças remotas via `onRemoteChange`. Se um
backend não tiver "tempo real", o app ainda atualiza sozinho a cada 20s
(há um `setInterval` de segurança no `iniciarApp`).
