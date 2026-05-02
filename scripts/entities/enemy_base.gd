extends Area2D
class_name EnemyBase

@export var enemy_id: String = "corrupcao_radicular"

@onready var sprite = $Sprite2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func interact() -> void:
    _start_combat()

func _on_body_entered(body: Node) -> void:
    if body.name == "Player":
        _start_combat()

func _start_combat() -> void:
    var enemy_data = _get_enemy_data()
    DialogueManager.start_combat(enemy_data)

func _get_enemy_data() -> Dictionary:
    var json_text = FileAccess.get_file_as_string("res://data/enemies.json")
    var data = JSON.parse_string(json_text)
    if data is Dictionary:
        return data.get(enemy_id, {})
    return {}
