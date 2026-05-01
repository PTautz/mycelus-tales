# Gerar Sprites com GPT-Image-2

Este projeto ja vem com um lote de prompts em:

`C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\tmp\imagegen\mycelium-sprites.jsonl`

Os prompts seguem o handoff de arte do Mycelium Tales e geram sheets conceituais para:

- protagonista
- anciao
- mercador
- caracol
- guerreiro
- mago
- naturalista
- viajante evoluido
- Corrupcao Radicular

## 1. Preparar ambiente

No PowerShell:

```powershell
$env:CODEX_HOME = "$HOME\\.codex"
$env:IMAGE_GEN = "$env:CODEX_HOME\\skills\\.system\\imagegen\\scripts\\image_gen.py"
```

Defina sua chave da API:

```powershell
$env:OPENAI_API_KEY = "SUA_CHAVE_AQUI"
```

## 2. Instalar dependencia

Se voce tiver `uv`:

```powershell
uv pip install openai pillow
```

Se nao tiver `uv`, use:

```powershell
python -m pip install openai pillow
```

## 3. Testar em dry-run

```powershell
python $env:IMAGE_GEN generate-batch `
  --input "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\tmp\imagegen\mycelium-sprites.jsonl" `
  --out-dir "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\output\imagegen" `
  --dry-run
```

## 4. Gerar de verdade no GPT-Image-2

```powershell
python $env:IMAGE_GEN generate-batch `
  --input "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\tmp\imagegen\mycelium-sprites.jsonl" `
  --out-dir "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\output\imagegen" `
  --concurrency 3
```

## 5. Limpar fundo verde para PNG com alpha

Os prompts usam fundo solido `#00ff00` para facilitar o recorte. Depois de gerar:

```powershell
python "$env:CODEX_HOME\\skills\\.system\\imagegen\\scripts\\remove_chroma_key.py" `
  --input "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\output\imagegen\prota-sheet.png" `
  --out "C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\output\imagegen\prota-sheet-alpha.png" `
  --auto-key border `
  --soft-matte `
  --transparent-threshold 12 `
  --opaque-threshold 220 `
  --despill
```

Repita para os demais sheets.

## 6. Refinar no Aseprite

O proprio handoff alerta para isso. Fluxo recomendado:

1. Abra o PNG no Aseprite.
2. Use `Sprite > Color Mode > Indexed`.
3. Reduza a paleta para no maximo 8 cores por personagem ou cena.
4. Remova anti-aliasing escondido.
5. Corte e reorganize os frames do idle.
6. Exporte os frames finais como sprite sheet real de jogo.

## 7. Destino sugerido dos arquivos

- personagens: `C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\assets\sprites\characters\`
- inimigos: `C:\Users\panto\OneDrive\Documentos\New project\mycelium-tales\assets\sprites\enemies\`

## Observacao importante

`gpt-image-2` e otimo para sheet conceitual consistente e retratos base, mas o acabamento final de sprite de producao ainda precisa de limpeza manual para ficar fiel ao pixel art puro do projeto.
