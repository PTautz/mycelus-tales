extends CanvasLayer

@onready var panel = $Control/Panel
@onready var name_label = $Control/Panel/Margin/VBox/NameLabel
@onready var line_label = $Control/Panel/Margin/VBox/LineLabel
@onready var buttons = [
    $Control/Panel/Margin/VBox/Choices/ChoiceA,
    $Control/Panel/Margin/VBox/Choices/ChoiceB,
    $Control/Panel/Margin/VBox/Choices/ChoiceC
]
@onready var close_button = $Control/Panel/Margin/VBox/CloseButton

var _full_text = ""
var _visible_chars = 0

func _ready() -> void:
    DialogueManager.register_dialogue_ui(self)
    close_button.pressed.connect(DialogueManager.close_dialogue)
    for i in range(buttons.size()):
        buttons[i].pressed.connect(_on_choice_pressed.bind(i))
    hide()

func _process(_delta: float) -> void:
    if not visible:
        return
    if _visible_chars < _full_text.length():
        _visible_chars += 1
        line_label.text = _full_text.substr(0, _visible_chars)

func open_dialogue(npc_id: String, options: Array) -> void:
    show()
    name_label.text = npc_id.to_upper()
    set_line("O silencio pulsa entre voces e esporos.")
    for i in range(buttons.size()):
        var option = options[i]
        buttons[i].text = option.get("label", "...")
        buttons[i].visible = true

func set_waiting(text: String) -> void:
    set_line(text)

func set_line(text: String) -> void:
    _full_text = text
    _visible_chars = 0
    line_label.text = ""

func _on_choice_pressed(index: int) -> void:
    DialogueManager.choose_option(index)
