# 🗂️ Registro de Decisões (ADR)

Cada decisão técnica relevante do projeto fica registrada aqui, num arquivo
curto. O objetivo é simples: **daqui a anos, qualquer pessoa entende POR QUE o
sistema é do jeito que é** — e qual benefício aquela escolha trouxe.

> "ADR" = *Architecture Decision Record* (Registro de Decisão de Arquitetura).
> Não precisa entender o termo — é só uma ficha de decisão.

## Como funciona
1. Toda decisão técnica relevante é **proposta** primeiro (em português claro).
2. Só é **implementada após aprovação** explícita (ver Governança no `MASTER-PLAN.md`).
3. Depois de aprovada, vira um arquivo `ADR-XXXX-titulo.md` aqui, usando o modelo abaixo.

## Modelo (copie para criar uma nova decisão)

```markdown
# ADR-XXXX — <título da decisão>

- **Data:** AAAA-MM-DD
- **Status:** Proposta | Aprovada | Substituída por ADR-YYYY
- **Aprovado por:** <nome>

## Contexto
Qual problema ou necessidade levou a esta decisão.

## Decisão
O que foi decidido, de forma direta.

## Alternativas consideradas
- Opção A — ...
- Opção B — ...

## Consequências técnicas
O que muda no sistema (código, banco, segurança, manutenção).

## Impacto operacional (no escritório)
Como isso afeta o dia a dia da equipe e/ou dos clientes.

## Benefício esperado
- ⏱️ **Tempo:** ...
- ✅ **Qualidade:** ...
- 🛡️ **Redução de erros:** ...
```

## Índice de decisões
- [ADR-0001 — Adotar registro de decisões (ADR)](ADR-0001-registro-de-decisoes.md)
- [ADR-0002 — Isolamento de acesso por pessoa ("gavetas por pessoa")](ADR-0002-isolamento-por-pessoa.md)
- [ADR-0003 — Senhas mais fortes (PINs aleatórios de 6 dígitos)](ADR-0003-senhas-fortes.md)
- [ADR-0004 — Fiscal também faz contábil das próprias empresas](ADR-0004-fiscal-faz-contabil.md)
- [ADR-0005 — Equipe pode editar as Observações da ficha](ADR-0005-equipe-edita-observacoes.md)
- [ADR-0006 — "Continuar conectada" (sessão persistente)](ADR-0006-continuar-conectada.md)
- [ADR-0007 — Bancos isolados por empresa + equipe pode editar](ADR-0007-bancos-isolados-equipe.md)
- [ADR-0008 — Painel de Monitoramento da gestora](ADR-0008-painel-monitoramento.md)
- [ADR-0009 — Relatório mostra também as empresas concluídas](ADR-0009-relatorio-mostra-concluidas.md)
- [ADR-0010 — Relatórios: filtro por Regime + Exportar/Imprimir](ADR-0010-relatorio-regime-export.md)
- [ADR-0011 — Renomear empresa + Editar banco](ADR-0011-renomear-empresa-editar-banco.md)
- [ADR-0012 — Central de gestão de empresas (Administração)](ADR-0012-central-gestao-empresas.md)
- [ADR-0013 — Impressão do relatório em várias páginas](ADR-0013-impressao-relatorio-multipaginas.md)
