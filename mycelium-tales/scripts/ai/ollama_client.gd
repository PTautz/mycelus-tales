extends Node
class_name OllamaClient

const URL = "http://localhost:11434/api/generate"
const MODEL = "llama3.2:3b"
const TIMEOUT_SEC = 2.0

signal response_ready(text: String)
signal request_failed

func generate(prompt: String) -> void:
    var http = HTTPRequest.new()
    add_child(http)
    http.timeout = TIMEOUT_SEC
    http.request_completed.connect(_on_done.bind(http))
    var body = JSON.stringify({
        "model": MODEL,
        "prompt": prompt,
        "stream": false
    })
    var err = http.request(
        URL,
        ["Content-Type: application/json"],
        HTTPClient.METHOD_POST,
        body
    )
    if err != OK:
        request_failed.emit()
        http.queue_free()

func _on_done(result: int, _code: int, _headers, body, http) -> void:
    http.queue_free()
    if result != HTTPRequest.RESULT_SUCCESS:
        request_failed.emit()
        return
    var parsed = JSON.parse_string(body.get_string_from_utf8())
    if parsed is Dictionary and parsed.has("response"):
        response_ready.emit(String(parsed["response"]).strip_edges())
        return
    request_failed.emit()
