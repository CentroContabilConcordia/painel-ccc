# ADR-0005 — Equipe pode editar as Observações da ficha

- **Data:** 2026-06-30
- **Status:** Aprovada
- **Aprovado por:** Patrícia

## Contexto
As meninas (equipe) não conseguiam digitar nas **Observações e Particularidades**
da ficha — a ficha inteira era só-leitura para quem não é gestora. Observação é
um campo colaborativo (avisos/particularidades) e a equipe precisa registrar.

## Decisão
Liberar o campo **Observações** (adicionar e remover) para a **equipe**. Os demais
campos cadastrais (CNPJ, regime, etc.) seguem **só-leitura** para a equipe (só
gestora edita). No banco, a RLS de **UPDATE** da tabela `empresas` passa a permitir
quem **já enxerga** a empresa (gestora; fiscal dona; qualquer contábil). Criar e
excluir empresa continuam **só para gestora**.

## Consequências técnicas
- App: seção "Observações" sempre editável; `adicionarObs`/`deletarObs` sem trava
  de gestora; demais campos da ficha continuam readonly para a equipe.
- RLS: substituída a policy "gerir empresas" (gestora p/ tudo) por três:
  `inserir`/`excluir` (gestora) e `atualizar` (quem vê a empresa).
- **Nuance de segurança:** via API, a equipe poderia atualizar outros campos da
  ficha das **próprias** empresas (a tela trava, mas a regra é por linha, não por
  campo). Aceitável para equipe interna confiável. Se precisar de rigor, mover as
  observações para uma tabela própria no futuro.

## Impacto operacional (no escritório)
- A equipe registra avisos/particularidades direto na ficha das suas empresas.

## Benefício esperado
- ✅ **Qualidade:** informação no lugar certo, colaborativa.
- ⏱️ **Tempo:** equipe não depende da gestora para anotar.
- 🛡️ **Risco:** baixo; isolamento mantido (cada uma só nas suas; contábil nas suas).
