# ADR-0003 — Senhas mais fortes (PINs aleatórios de 6 dígitos)

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
Os PINs iniciais eram óbvios e sequenciais (1234, 1111, 2222, …). Dava para
adivinhar tentando em sequência — risco de acesso indevido entre contas.

## Decisão
Trocar os 9 PINs por **números aleatórios de 6 dígitos**, gerados e entregues
diretamente à Patrícia (canal seguro). As senhas continuam **criptografadas no
servidor** (Supabase) e com **limite de tentativas** contra chute.
**Os PINs NÃO são guardados neste repositório** (nem em arquivos versionados).

## Alternativas consideradas
- **PIN de 4 dígitos** — mais fácil, porém menos seguro.
- **Cada pessoa escolhe a própria senha** — ideal a longo prazo, mas exige uma
  tela de "trocar minha senha" no app; fica para uma etapa futura.

## Consequências técnicas
- Nenhuma mudança de código: o login já usa o que a pessoa digita.
- A troca foi feita conta a conta (entrando com a senha atual e atualizando),
  sem necessidade de chave de administrador.

## Impacto operacional (no escritório)
- A equipe passa a usar o PIN novo (mesma forma de entrar, só muda o número).
- Reduz o risco de alguém acessar a conta de outra pessoa por tentativa.

## Benefício esperado
- 🛡️ **Redução de erros/risco:** PIN aleatório de 6 dígitos é muito mais difícil
  de adivinhar (1 milhão de combinações + limite de tentativas).
- ✅ **Qualidade:** acesso confiável e individual.
- ⏱️ **Tempo:** neutro (sem mudança no dia a dia).

## Pendência futura
Criar uma telinha de "trocar minha senha" para cada pessoa personalizar o PIN.
