# Mycelus Tales

Base de desenvolvimento do MVP em Godot 4 para o vertical slice de `Veuspora`.

## Stack

- Godot `4.6.1`
- GDScript
- Ollama local para dialogo
- SQLite opcional para memoria persistente via addon

## Estrutura

- `scenes/`: mundo, entidades, inimigos e UI
- `scripts/`: gameplay, dialogo, combate e integracoes
- `data/`: biomas, NPCs, inimigos e fallbacks
- `assets/source-sheets/`: referencias e rascunhos de sprite
- `assets/sprites/`: sprites finais usados no jogo
- `docs/`: guias de pipeline, importacao e setup

## Estado atual

- projeto inicial abre no Godot 4.6.1
- vertical slice com player, NPC, combate e bioma base
- compatibilidade de scripts ajustada para parse mais conservador
- fluxo de arte focado em sprites manuais

## Fluxo recomendado

1. Abrir `project.godot`
2. Testar `res://scenes/main.tscn`
3. Produzir ou desenhar sprites manualmente
4. Importar sprites finais em `assets/sprites/`
5. Substituir placeholders nas cenas
6. Ativar `godot-sqlite` se quiser memoria persistente real
7. Rodar e iterar em commits pequenos

## Arte

- nao existe mais pipeline de geracao automatica no repositorio
- qualquer sprite novo deve entrar como referencia em `assets/source-sheets/` ou como asset final em `assets/sprites/`
- priorizar Aseprite e importacao manual no Godot

## Git

O repositorio local ja esta inicializado na raiz do workspace e o projeto ja possui commit inicial.
