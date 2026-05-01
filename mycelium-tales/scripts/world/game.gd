extends Node

var player_id = "player_01"
var current_biome = "veuspora"
var player_stats = {
    "hp": 70,
    "hp_max": 70,
    "esp": 60,
    "esp_max": 60,
    "res": 50,
    "con": 90
}

signal biome_changed(biome_id: String)

func set_biome(biome_id: String) -> void:
    if current_biome == biome_id:
        return
    current_biome = biome_id
    biome_changed.emit(biome_id)
