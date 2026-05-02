# Como usar os sheets manuais

Voce ja tem uma base de arte melhor que os placeholders e sem custo de API. Os arquivos de trabalho podem ficar fora do repositorio e ser copiados para:

`assets/source-sheets/`

## O que veio no pacote

### Personagens

- `prota-sheet-alpha.png`
- `prota-v1-sheet-alpha.png`
- `ancien-sheet-alpha.png`
- `merc-sheet-alpha.png`
- `merc-v1-sheet-alpha.png`
- `snail-sheet-alpha.png`

### Inimigo

- `corrupcao-sheet-alpha.png`

### Tiles e props

- `tiles-chao-sheet-alpha.png`
- `props-flora-sheet-alpha.png`
- `props-ruinas-sheet-alpha.png`

## Observacao importante

Considere esses arquivos como base de trabalho. O fluxo ideal agora e:

1. manter os arquivos originais como fonte
2. abrir no Aseprite
3. limpar, recortar e padronizar
4. exportar sprites finais para `assets/sprites/`

## Organizacao recomendada

### Fontes originais

- personagens: `assets/source-sheets/characters/`
- inimigos: `assets/source-sheets/enemies/`
- tiles: `assets/source-sheets/tiles/`
- props: `assets/source-sheets/props/`

### Sprites prontos para o jogo

- personagens: `assets/sprites/characters/`
- inimigos: `assets/sprites/enemies/`
- tiles: `assets/sprites/tiles/`

## Como decidir qual versao usar

### Protagonista

Compare:

- `prota-sheet-alpha.png`
- `prota-v1-sheet-alpha.png`

Escolha com base em:

- leitura da silhueta em tamanho pequeno
- legibilidade dos olhos
- clareza do cajado
- contraste entre capa, roupa e chapeu

### Mercador

Compare:

- `merc-sheet-alpha.png`
- `merc-v1-sheet-alpha.png`

Escolha com base em:

- se a silhueta funciona em 32x32
- se o rosto continua misterioso
- se os detalhes extras nao viram ruido visual

## Pipeline recomendado

1. copie os sheets para `assets/source-sheets/`
2. abra no Aseprite
3. converta para paleta indexada
4. reduza para no maximo 8 cores por sprite ou cena
5. recorte os 4 angulos principais
6. exporte o sprite final
7. importe no Godot com `Filter = Nearest` e `Mipmaps = Off`

## Prioridade ideal para o vertical slice

1. protagonista
2. anciao
3. Corrupcao Radicular
4. tiles de chao
5. caracol
6. mercador
7. props

## Onde ligar no projeto

- player: `scenes/entities/player.tscn`
- anciao: `scenes/entities/npcs/ancien.tscn`
- inimigo: `scenes/enemies/corrupcao_radicular.tscn`
- mundo inicial: `scenes/world/biomes/veuspora.tscn`
