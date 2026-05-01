extends CharacterBody2D

const SPEED := 80.0

var facing = Vector2.DOWN
var is_in_dialogue = false
var is_in_combat = false

@onready var sprite = $Sprite2D
@onready var interact_area = $InteractArea

func _ready() -> void:
    DialogueManager.dialogue_state_changed.connect(_on_dialogue_state_changed)
    DialogueManager.combat_state_changed.connect(_on_combat_state_changed)

func _physics_process(_delta: float) -> void:
    if is_in_dialogue or is_in_combat:
        velocity = Vector2.ZERO
        move_and_slide()
        return

    var dir = Vector2(
        Input.get_axis("ui_left", "ui_right"),
        Input.get_axis("ui_up", "ui_down")
    ).normalized()

    velocity = dir * SPEED
    if dir != Vector2.ZERO:
        facing = dir
    _update_placeholder_sprite(dir)
    move_and_slide()

    if Input.is_action_just_pressed("ui_accept"):
        _try_interact()

func _try_interact() -> void:
    for area in interact_area.get_overlapping_areas():
        var owner = area.get_parent()
        if owner != null and owner.has_method("interact"):
            owner.interact()
            return
    for body in interact_area.get_overlapping_bodies():
        if body.has_method("interact"):
            body.interact()
            return

func _update_placeholder_sprite(dir: Vector2) -> void:
    if dir == Vector2.ZERO:
        sprite.modulate = Color(0.88, 0.88, 0.87)
        return
    if abs(dir.x) > abs(dir.y):
        sprite.modulate = Color(1.0, 0.64, 0.54)
    elif dir.y < 0.0:
        sprite.modulate = Color(0.0, 0.96, 0.83)
    else:
        sprite.modulate = Color(0.83, 0.63, 0.09)

func _on_dialogue_state_changed(active: bool) -> void:
    is_in_dialogue = active

func _on_combat_state_changed(active: bool) -> void:
    is_in_combat = active
