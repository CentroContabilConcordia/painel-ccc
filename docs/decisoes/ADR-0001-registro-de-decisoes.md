# ADR-0001 — Adotar registro de decisões (ADR)

- **Data:** 2026-06-29
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
O projeto deixou de ser um experimento e passou a ser tratado como um **produto
de software** que precisa evoluir por anos. Sem registrar o *porquê* das escolhas
técnicas, o conhecimento se perde e o sistema fica difícil de manter e evoluir.

## Decisão
Manter um **registro de decisões** em `docs/decisoes/`, com um arquivo curto por
decisão. Cada decisão técnica relevante é **proposta antes** e só implementada
**após aprovação explícita**. Cada registro inclui obrigatoriamente: impacto
operacional no escritório, quem aprovou, e o benefício esperado em tempo,
qualidade ou redução de erros.

## Alternativas consideradas
- **Não registrar nada** — mais rápido no curto prazo, mas o "porquê" se perde e
  decisões acabam sendo refeitas/quebradas sem querer.
- **Ferramenta externa de gestão** — exagero para o tamanho atual do projeto.

## Consequências técnicas
- Nenhuma mudança no aplicativo — é só documentação versionada no GitHub.
- Pequeno custo de disciplina: escrever uma ficha curta a cada decisão.

## Impacto operacional (no escritório)
- A direção do escritório passa a **enxergar e aprovar** o rumo técnico, sem
  precisar entender de programação.
- Reduz dependência de uma única pessoa "que sabe como funciona".

## Benefício esperado
- ⏱️ **Tempo:** menos retrabalho futuro; onboarding mais rápido de quem entrar depois.
- ✅ **Qualidade:** decisões coerentes e rastreáveis ao longo dos anos.
- 🛡️ **Redução de erros:** evita quebrar à toa escolhas feitas por bons motivos.
