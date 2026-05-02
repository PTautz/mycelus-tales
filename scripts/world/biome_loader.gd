extends Node
class_name BiomeLoader

const BIOME_SCENES = {
    "veuspora": "res://scenes/world/biomes/veuspora.tscn",
    "feira": "res://scenes/world/biomes/feira.tscn",
    "ginkgo": "res://scenes/world/biomes/ginkgo.tscn",
    "humido": "res://scenes/world/biomes/humido.tscn",
    "clareira": "res://scenes/world/biomes/clareira.tscn"
}

func load_biome(biome_id: String) -> Node:
    var scene_path: String = BIOME_SCENES.get(biome_id, BIOME_SCENES["veuspora"])
    var packed: PackedScene = load(scene_path) as PackedScene
    if packed == null:
        push_error("Nao foi possivel carregar bioma: %s" % biome_id)
        return Node2D.new()
    Game.set_biome(biome_id)
    return packed.instantiate()
