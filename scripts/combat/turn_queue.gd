extends Node
class_name TurnQueue

var entries = []

func reset() -> void:
    entries.clear()

func seed_default() -> void:
    entries = ["player", "enemy"]

func next_turn() -> String:
    if entries.is_empty():
        seed_default()
    var current = entries.pop_front()
    entries.push_back(current)
    return str(current)
