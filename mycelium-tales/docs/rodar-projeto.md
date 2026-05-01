# Como Rodar o Projeto

## 1. Abrir no Godot

1. Instale Godot 4.x.
2. Abra o Godot.
3. Clique em `Import`.
4. Escolha o arquivo:

`C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\project.godot`

## 2. Instalar o addon SQLite

O projeto esta preparado para usar `godot-sqlite`, mas tambem tem fallback se o addon nao estiver instalado.

Fluxo sugerido:

1. Baixe o addon `godot-sqlite`.
2. Copie a pasta do addon para:

`C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\addons\`

3. No Godot, abra `Project > Project Settings > Plugins`.
4. Ative o plugin.

## 3. Configurar imports de pixel art

Para cada sprite importado:

1. Selecione o arquivo no FileSystem.
2. Aba `Import`.
3. Filter: `Nearest`
4. Mipmaps: `Off`
5. Compression: preferir sem blur
6. Clique em `Reimport`

## 4. Rodar a cena principal

No Godot:

1. Abra `res://scenes/main.tscn`
2. Clique em `Play Current Scene`

Ou rode o projeto inteiro com `F5`.

## 5. Controles atuais

- `WASD` para mover
- `Espaco` para interagir

## 6. Fluxo esperado do MVP

1. O player nasce em `Veuspora`
2. Anda ate o anciao
3. Aperta `Espaco`
4. Escolhe uma das 3 respostas
5. Ollama responde, ou entra fallback se nao houver resposta
6. Encoste no inimigo para abrir combate

## 7. Se o dialogo com Ollama nao funcionar

O projeto usa:

`http://localhost:11434/api/generate`

Entao voce precisa ter o Ollama rodando localmente com um modelo compativel, por exemplo:

- `llama3.2:3b`
- `phi3:mini`

Se o Ollama nao estiver ativo, o fallback textual entra no lugar sem quebrar o jogo.
