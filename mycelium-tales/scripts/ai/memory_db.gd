extends Node
class_name MemoryDB

const DB_PATH = "user://memory.db"
var db = null
var _available = false

func _ready() -> void:
    _available = ClassDB.class_exists("SQLite")
    if not _available:
        push_warning("Addon godot-sqlite nao encontrado. Memoria persistente em SQLite desativada.")
        return
    db = ClassDB.instantiate("SQLite")
    db.path = DB_PATH
    db.open_db()
    _init_schema()

func _init_schema() -> void:
    if db == null:
        return
    db.query("CREATE TABLE IF NOT EXISTS npc_memory (id INTEGER PRIMARY KEY AUTOINCREMENT, npc_id TEXT NOT NULL, player_id TEXT NOT NULL, ts INTEGER NOT NULL, tone TEXT, player_said TEXT, npc_replied TEXT, biome_id TEXT, importance INTEGER DEFAULT 1)")
    db.query("CREATE TABLE IF NOT EXISTS npc_personality (npc_id TEXT PRIMARY KEY, base_prompt TEXT NOT NULL, archetype TEXT, default_mood TEXT)")
    db.query("CREATE TABLE IF NOT EXISTS world_state (key TEXT PRIMARY KEY, value TEXT)")
    _seed_personalities()

func _seed_personalities() -> void:
    if db == null:
        return
    var npcs_json = FileAccess.get_file_as_string("res://data/npcs.json")
    var npcs = JSON.parse_string(npcs_json)
    if npcs is Dictionary:
        for npc_id in npcs.keys():
            var n = npcs[npc_id]
            db.query_with_bindings(
                "INSERT OR IGNORE INTO npc_personality VALUES (?,?,?,?)",
                [npc_id, n.get("base_prompt", ""), n.get("archetype", ""), n.get("default_mood", "neutro")]
            )

func recent(npc_id: String, player_id: String, limit: int = 10) -> Array:
    if db == null:
        return []
    db.query_with_bindings(
        "SELECT * FROM npc_memory WHERE npc_id=? AND player_id=? ORDER BY ts DESC LIMIT ?",
        [npc_id, player_id, limit]
    )
    return db.query_result

func insert(npc_id: String, player_id: String, tone: String, said: String, replied: String) -> void:
    if db == null:
        return
    db.query_with_bindings(
        "INSERT INTO npc_memory (npc_id,player_id,ts,tone,player_said,npc_replied,biome_id) VALUES (?,?,?,?,?,?,?)",
        [npc_id, player_id, int(Time.get_unix_time_from_system()), tone, said, replied, Game.current_biome]
    )

func get_personality(npc_id: String) -> Dictionary:
    if db == null:
        return {"base_prompt": "", "archetype": "", "default_mood": "neutro"}
    db.query_with_bindings("SELECT * FROM npc_personality WHERE npc_id=?", [npc_id])
    if db.query_result.size() > 0:
        return db.query_result[0]
    return {"base_prompt": "", "archetype": "", "default_mood": "neutro"}
