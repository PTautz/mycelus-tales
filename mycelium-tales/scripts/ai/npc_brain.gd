extends Node
class_name NpcBrain

var ollama = OllamaClient.new()

signal reply_ready(text: String)

var _npc_id = "ancien"
var _tone = "neutro"
var _said = ""
var _memory_db = null

func _ready() -> void:
    add_child(ollama)
    ollama.response_ready.connect(_on_reply)
    ollama.request_failed.connect(_on_fail)

func request_reply(npc_id: String, player_input: String, tone: String = "neutro", memory_db = null) -> void:
    _npc_id = npc_id
    _tone = tone
    _said = player_input
    _memory_db = memory_db

    var personality = {}
    var mem_text = "(nenhuma memoria ainda)"
    if memory_db != null:
        personality = memory_db.get_personality(npc_id)
        var memories = memory_db.recent(npc_id, Game.player_id, 8)
        if not memories.is_empty():
            var lines = []
            for m in memories:
                lines.append("Viajante: %s\nVoce: %s" % [m.get("player_said", ""), m.get("npc_replied", "")])
            mem_text = "\n---\n".join(lines)

    var prompt = """[Personalidade]
%s

[Memorias recentes com este viajante]
%s

[Bioma atual] %s
[Tom da fala do viajante] %s
[Viajante diz] %s

Responda em 1-2 frases curtas no tom melancolico-contemplativo do mundo Mycelium Tales.
Nao mencione que voce e uma IA. Nao use aspas. Portugues brasileiro.""" % [
        personality.get("base_prompt", ""),
        mem_text,
        Game.current_biome,
        tone,
        player_input
    ]

    ollama.generate(prompt)

func _on_reply(text: String) -> void:
    if _memory_db != null:
        _memory_db.insert(_npc_id, Game.player_id, _tone, _said, text)
    reply_ready.emit(text)

func _on_fail() -> void:
    var fb_json = FileAccess.get_file_as_string("res://data/dialogue_fallbacks.json")
    var fb = JSON.parse_string(fb_json)
    var line = "..."
    if fb is Dictionary:
        var npc_fb = fb.get(_npc_id, {})
        line = npc_fb.get(_tone, npc_fb.get("neutro", "..."))
    if _memory_db != null:
        _memory_db.insert(_npc_id, Game.player_id, _tone, _said, line)
    reply_ready.emit(line)
