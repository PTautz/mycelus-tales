extends CanvasLayer

@onready var root_panel = $Control/Panel
@onready var enemy_label = $Control/Panel/Margin/VBox/Header/EnemyName
@onready var hp_label = $Control/Panel/Margin/VBox/Stats/HP
@onready var esp_label = $Control/Panel/Margin/VBox/Stats/ESP
@onready var enemy_hp_label = $Control/Panel/Margin/VBox/Stats/EnemyHP
@onready var log_label = $Control/Panel/Margin/VBox/Log
@onready var buttons = {
    "ATACAR": $Control/Panel/Margin/VBox/Actions/Attack,
    "ESPORULAR": $Control/Panel/Margin/VBox/Actions/Spore,
    "SIMBIOSE": $Control/Panel/Margin/VBox/Actions/Symbiosis,
    "FUGIR": $Control/Panel/Margin/VBox/Actions/Flee
}
@onready var manager = $CombatManager

func _ready() -> void:
    DialogueManager.register_combat_ui(self)
    manager.combat_log.connect(_append_log)
    manager.turn_changed.connect(_set_player_turn)
    manager.combat_ended.connect(_on_combat_ended)
    manager.stats_changed.connect(_update_stats)
    for action in buttons.keys():
        buttons[action].pressed.connect(manager.player_action.bind(action))
    hide()

func open_combat(enemy_data: Dictionary) -> void:
    show()
    log_label.text = ""
    enemy_label.text = String(enemy_data.get("name", "Inimigo"))
    manager.start(enemy_data)

func _append_log(text: String) -> void:
    if log_label.text.is_empty():
        log_label.text = text
    else:
        log_label.text += "\n" + text

func _set_player_turn(is_player: bool) -> void:
    for button in buttons.values():
        button.disabled = not is_player

func _update_stats(player: Dictionary, enemy: Dictionary) -> void:
    hp_label.text = "HP %d/%d" % [int(player.get("hp", 0)), int(player.get("hp_max", 0))]
    esp_label.text = "ESP %d/%d" % [int(player.get("esp", 0)), int(player.get("esp_max", 0))]
    enemy_hp_label.text = "INIMIGO %d/%d" % [int(enemy.get("hp", 0)), int(enemy.get("hp_max", 0))]

func _on_combat_ended(_victory: bool) -> void:
    await get_tree().create_timer(1.4).timeout
    DialogueManager.end_combat()
