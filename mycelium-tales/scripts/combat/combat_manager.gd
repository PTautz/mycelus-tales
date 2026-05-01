extends Node
class_name CombatManager

enum State { IDLE, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var state = State.IDLE
var player_stats = {}
var enemy_stats = {}

signal combat_log(text: String)
signal combat_ended(victory: bool)
signal turn_changed(is_player: bool)
signal stats_changed(player: Dictionary, enemy: Dictionary)

func start(enemy_data: Dictionary) -> void:
    player_stats = Game.player_stats.duplicate(true)
    enemy_stats = enemy_data.duplicate(true)
    state = State.PLAYER_TURN
    turn_changed.emit(true)
    stats_changed.emit(player_stats, enemy_stats)
    combat_log.emit("O silencio se adensa.")

func player_action(action: String) -> void:
    if state != State.PLAYER_TURN:
        return

    match action:
        "ATACAR":
            var dmg = randi_range(8, 15)
            enemy_stats["hp"] = int(enemy_stats.get("hp", 0)) - dmg
            combat_log.emit("Voce ataca. A Corrupcao perde %d HP." % dmg)
        "ESPORULAR":
            if int(player_stats.get("esp", 0)) < 12:
                combat_log.emit("Esporos insuficientes.")
                return
            player_stats["esp"] = int(player_stats["esp"]) - 12
            var spore_dmg = randi_range(15, 25)
            enemy_stats["hp"] = int(enemy_stats.get("hp", 0)) - spore_dmg
            combat_log.emit("Voce libera esporos. O ar fica cintilante. -%d HP." % spore_dmg)
        "SIMBIOSE":
            if int(player_stats.get("esp", 0)) < 25:
                combat_log.emit("Esporos insuficientes.")
                return
            player_stats["esp"] = int(player_stats["esp"]) - 25
            var heal = randi_range(12, 20)
            player_stats["hp"] = min(int(player_stats["hp"]) + heal, int(player_stats["hp_max"]))
            combat_log.emit("Simbiose. Voce recupera %d HP." % heal)
        "FUGIR":
            if randf() < 0.5:
                combat_log.emit("Voce escapa para a escuridao.")
                state = State.IDLE
                combat_ended.emit(false)
                return
            combat_log.emit("A fuga falhou. A Corrupcao bloqueia o caminho.")

    Game.player_stats = player_stats.duplicate(true)
    stats_changed.emit(player_stats, enemy_stats)
    _check_end()
    if state == State.PLAYER_TURN:
        state = State.ENEMY_TURN
        turn_changed.emit(false)
        await get_tree().create_timer(1.1).timeout
        _enemy_turn()

func _enemy_turn() -> void:
    var dmg = randi_range(int(enemy_stats.get("attack_min", 6)), int(enemy_stats.get("attack_max", 14)))
    player_stats["hp"] = int(player_stats["hp"]) - dmg
    Game.player_stats["hp"] = player_stats["hp"]
    combat_log.emit("A Corrupcao recua. Algo na raiz do mundo estremeceu. Voce perde %d HP." % dmg)
    stats_changed.emit(player_stats, enemy_stats)
    _check_end()
    if state == State.ENEMY_TURN:
        state = State.PLAYER_TURN
        turn_changed.emit(true)

func _check_end() -> void:
    if int(enemy_stats.get("hp", 0)) <= 0:
        state = State.VICTORY
        combat_log.emit("A Corrupcao se dissolve. A rede respira.")
        combat_ended.emit(true)
    elif int(player_stats.get("hp", 0)) <= 0:
        state = State.DEFEAT
        combat_log.emit("Voce cai. A rede guarda sua passagem.")
        combat_ended.emit(false)
