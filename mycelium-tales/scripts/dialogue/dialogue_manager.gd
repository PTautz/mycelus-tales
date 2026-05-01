extends Node

signal dialogue_state_changed(active: bool)
signal combat_state_changed(active: bool)

var dialogue_ui = null
var combat_ui = null
var active_npc = null
var active_world = null
var current_options = [
    {"label": "Perguntar pela rede", "tone": "curiosidade", "text": "O que a rede quer me mostrar?"},
    {"label": "Responder com cautela", "tone": "ceticismo", "text": "Nem toda memoria merece ser seguida."},
    {"label": "Abrir o coracao", "tone": "empatia", "text": "Estou cansado de caminhar sozinho."}
]

func register_dialogue_ui(ui) -> void:
    dialogue_ui = ui
    if dialogue_ui != null:
        dialogue_ui.hide()

func register_combat_ui(ui) -> void:
    combat_ui = ui
    if combat_ui != null:
        combat_ui.hide()

func register_world(world) -> void:
    active_world = world

func open(npc) -> void:
    active_npc = npc
    dialogue_state_changed.emit(true)
    if dialogue_ui != null and dialogue_ui.has_method("open_dialogue"):
        dialogue_ui.call("open_dialogue", npc.npc_id, current_options)

func show_thinking() -> void:
    if dialogue_ui != null and dialogue_ui.has_method("set_waiting"):
        dialogue_ui.call("set_waiting", "...")

func display_line(text: String) -> void:
    if dialogue_ui != null and dialogue_ui.has_method("set_line"):
        dialogue_ui.call("set_line", text)

func choose_option(index: int) -> void:
    if active_npc == null:
        return
    if index < 0 or index >= current_options.size():
        return
    var option = current_options[index]
    active_npc.request_line(option.get("text", ""), option.get("tone", "neutro"))

func close_dialogue() -> void:
    active_npc = null
    dialogue_state_changed.emit(false)
    if dialogue_ui != null:
        dialogue_ui.hide()

func start_combat(enemy_data: Dictionary) -> void:
    combat_state_changed.emit(true)
    if combat_ui != null and combat_ui.has_method("open_combat"):
        combat_ui.call("open_combat", enemy_data)

func end_combat() -> void:
    combat_state_changed.emit(false)
    if combat_ui != null:
        combat_ui.hide()
