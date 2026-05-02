extends Node
class_name DialogueFallbacks

var data = {}

func _ready() -> void:
    var text = FileAccess.get_file_as_string("res://data/dialogue_fallbacks.json")
    var parsed = JSON.parse_string(text)
    if parsed is Dictionary:
        data = parsed

func get_line(npc_id: String, tone: String) -> String:
    var npc_data = data.get(npc_id, {})
    return npc_data.get(tone, npc_data.get("neutro", "..."))
