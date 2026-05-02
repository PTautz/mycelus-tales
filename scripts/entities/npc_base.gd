extends CharacterBody2D
class_name NpcBase

@export var npc_id: String = "ancien"
@export var default_tone: String = "neutro"

var brain = NpcBrain.new()
var memory = MemoryDB.new()

@onready var sprite = $Sprite2D

func _ready() -> void:
    add_child(brain)
    add_child(memory)
    brain.reply_ready.connect(_on_reply)
    sprite.modulate = Color(0.92, 0.3, 0.29)

func interact() -> void:
    DialogueManager.open(self)

func request_line(player_input: String, tone: String = default_tone) -> void:
    DialogueManager.show_thinking()
    brain.request_reply(npc_id, player_input, tone, memory)

func _on_reply(text: String) -> void:
    DialogueManager.display_line(text)
