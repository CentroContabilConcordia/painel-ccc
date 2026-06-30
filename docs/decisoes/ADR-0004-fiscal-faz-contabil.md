# ADR-0004 — Fiscal também faz contábil das próprias empresas

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
As meninas do fiscal (Cristiane, Cleonice, Julia, Gabriela) passarão a fazer
também a **contabilidade das próprias empresas** (as que estão na carteira fiscal
delas). A equipe contábil (Carla, Neusa, Marli) **continua fazendo todas** — o
contábil segue aberto.

## Decisão
Liberar para os usuários do **setor fiscal** o acesso à **aba Contábil**, mostrando
**só as próprias empresas** (aproveitando o isolamento da tabela `empresas` já
existente — ADR-0002). Contábil (Carla/Neusa/Marli) e gestoras: sem mudança
(continuam vendo todas).

## Alternativas consideradas
- **Responsável contábil por empresa** (um dono de contábil por empresa) — mais
  complexo e desnecessário, já que o contábil é compartilhado/aberto.

## Consequências técnicas
- Menu: usuários fiscais passam a ter **2 abas** (Fiscal + Contábil).
- Contagem de empresas no contábil ficou **dinâmica** (some o "276" fixo): fiscal
  vê "Minhas Empresas" (as dela); contábil/gestora vê "Todas as Empresas".
- As **tarefas** contábeis seguem num balde compartilhado (`ccc_v8`), sem
  isolamento fino por empresa — aceitável porque o contábil é aberto. Isolamento
  de tarefas continua como fase futura.

## Impacto operacional (no escritório)
- As fiscais cuidam da **carteira ponta a ponta** (fiscal + contábil das suas).
- A equipe contábil enxerga e faz **tudo** — nada some.

## Benefício esperado
- ⏱️ **Tempo:** menos troca de mão entre setores na mesma empresa.
- ✅ **Qualidade:** responsabilidade clara por carteira.
- 🛡️ **Risco:** neutro (mudança de permissão de tela; dados inalterados).
