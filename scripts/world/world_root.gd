extends Node2D

@onready var biome_layer = $BiomeLayer
@onready var player = $Player

var biome_loader = BiomeLoader.new()

func _ready() -> void:
    add_child(biome_loader)
    DialogueManager.register_world(self)
    _load_initial_biome()

func _load_initial_biome() -> void:
    for child in biome_layer.get_children():
        child.queue_free()
    var biome = biome_loader.load_biome(Game.current_biome)
    biome_layer.add_child(biome)
    biome.position = Vector2.ZERO
