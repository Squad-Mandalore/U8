extends Node

var process_id = ""
var agent = ""
var title = "NPC Conversation"

signal get_process_id(process_id: String)
signal get_message(message: String)
signal new_message
signal finish_message

var post_req
var backend_unreachable := false

var fallback_lines := [
    "Was zur Hölle? Ich glaub, mein Hirn ist weg!",
    "Ähm... Ich kann gerade nicht denken. Bin ich real?",
    "404: Gehirn nicht gefunden.",
    "Ich wollte was sagen, aber... Puff! Weg.",
    "Reden? Ich? Nee, heute nicht.",
    "Oh nein, mein Denken hat sich verabschiedet!",
    "Ich hab’s gleich... Moment... Moment... Äh...",
    "Fehler im System. Bitte später nochmal verwirren!",
    "Bin gerade geistig auf Weltreise.",
    "Sprache.exe ist abgestürzt."
]

func _ready():
    post_req = HTTPRequest.new()
    post_req.request_completed.connect(_set_process_id)
    add_child(post_req)
    $HTTPSSEClient.new_sse_event.connect(on_new_sse_event)

func on_new_sse_event(headers, event, data):
    match data["category"]:
        "end":
            finish_message.emit()
            $HTTPSSEClient.state = $HTTPSSEClient.ConnectionState.CONNECTED
        "output":
            get_message.emit(data["content"])
        "transform":
            pass

func post_message(message: String):
    if backend_unreachable:
        _send_fallback_response()
        return

    var url = "/processes/%s/agent/%s/actions/converse" % [process_id, agent]
    var headers = ["Content-Type: application/json", "Accept: text/event-stream"]
    var method = HTTPClient.METHOD_POST
    var body = JSON.stringify(message)
    $HTTPSSEClient.set_outgoing_request(method, url, headers, body)
    new_message.emit()

func _set_process_id(result, response_code, headers, body):
    var json = JSON.new()

    if json.parse(body.get_string_from_utf8()) != OK:
        printerr("Failed to parse JSON. Response body:", body.get_string_from_utf8())
        _handle_backend_unreachable()
        return

    var response = json.get_data()

    if typeof(response) == TYPE_DICTIONARY and response.has("process_id"):
        process_id = response.process_id
        get_process_id.emit(process_id)
        _connect_sse()
    else:
        printerr("No 'process_id' in response or response is invalid. Response:", response)
        _handle_backend_unreachable()

func _handle_backend_unreachable():
    backend_unreachable = true
    _send_fallback_response()

func _send_fallback_response():
    var fallback_text = fallback_lines[randi() % fallback_lines.size()]

    new_message.emit()
    await get_tree().create_timer(0.05).timeout

    get_message.emit("")
    await get_tree().create_timer(0.05).timeout

    for char in fallback_text:
        get_message.emit(char)
        await get_tree().create_timer(0.08).timeout

    finish_message.emit()


func set_agent(group: String):
    agent = group
    var url = "http://localhost:8080/processes"
    var headers = ["Content-Type: application/json"]
    var method = HTTPClient.METHOD_POST
    var body = JSON.stringify({
        "agent": agent,
        "title": title
    })
    post_req.request(url, headers, method, body)

func _connect_sse():
    var sub_url = ""
    $HTTPSSEClient.connect_to_host("localhost", sub_url, 8080)
