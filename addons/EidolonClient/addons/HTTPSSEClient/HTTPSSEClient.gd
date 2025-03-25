extends Node

signal new_sse_event(headers, event, data)
signal connected
signal connection_error(error)

const EVENT_TAG = "id:"
const DATA_TAG = "data:"
const CONTINUE_INTERNAL = "continue_internal"

# Connection state enum for clarity.
enum ConnectionState {
    DISCONNECTED,
    CONNECTED,
    REQUEST_SENT
}

var httpclient : HTTPClient
var state = ConnectionState.DISCONNECTED

var domain = ""
var url_after_domain = ""
var port = 0
var use_ssl = false
var verify_host = true
var json

var outgoing_request : Dictionary = {}
var response_buffer = ""  # Buffer to accumulate string data

func _ready():
    httpclient = HTTPClient.new()
    json = JSON.new()

func connect_to_host(domain: String, url_after_domain: String, port: int = -1, use_ssl: bool = false, verify_host: bool = true):
    self.domain = domain
    self.url_after_domain = url_after_domain
    self.port = port
    self.use_ssl = use_ssl
    self.verify_host = verify_host
    if state == ConnectionState.DISCONNECTED:
        attempt_to_connect()

func attempt_to_connect():
    var err = httpclient.connect_to_host(domain, port)
    if err == OK:
        state = ConnectionState.CONNECTED
    else:
        connection_error.emit("Connect error: " + str(err))

func set_outgoing_request(method, url, headers, body):
    # Set the outgoing request only when connected.
    # if state == ConnectionState.CONNECTED:
    outgoing_request = {"method": method, "url": url, "headers": headers, "body": body}
    attempt_to_send_request()

func attempt_to_send_request():
    if outgoing_request:
        var err = httpclient.request(outgoing_request["method"], outgoing_request["url"], outgoing_request["headers"], outgoing_request["body"])
        if err == OK:
            state = ConnectionState.REQUEST_SENT
            outgoing_request = {}
        else:
            connection_error.emit("Request error: " + str(err))

func _process(delta):
    if state == ConnectionState.DISCONNECTED:
        return

    httpclient.poll()
    var status = httpclient.get_status()

    # Handle connection errors and reconnect if needed.
    if status == HTTPClient.STATUS_CONNECTION_ERROR:
        state = ConnectionState.DISCONNECTED
        connection_error.emit("Connection error detected. Reconnecting...")
        attempt_to_connect()
        return

    # Transition from connecting to connected.
    if status == HTTPClient.STATUS_CONNECTED and state == ConnectionState.CONNECTED:
        connected.emit()
        attempt_to_send_request()

    # Read and process response chunks.
    if httpclient.has_response() or status == HTTPClient.STATUS_BODY:
        var headers = httpclient.get_response_headers_as_dictionary()
        var chunk = httpclient.read_response_body_chunk()
        if chunk.size() > 0:
            response_buffer += chunk.get_string_from_utf8()
            process_response_buffer(headers)

func process_response_buffer(headers):
    # Split the buffer into complete SSE messages (delimited by two newlines).
    while true:
        var delimiter_idx = response_buffer.find("\n\r")
        if delimiter_idx == -1:
            break
        var raw_event = response_buffer.substr(0, delimiter_idx).strip_edges()
        response_buffer = response_buffer.substr(delimiter_idx + 2, response_buffer.length())
        if raw_event != "":
            var event_data = parse_event(raw_event)
            if event_data and event_data.has("event") and event_data["event"] != CONTINUE_INTERNAL:
                new_sse_event.emit(headers, event_data["event"], event_data.get("data", null))

func parse_event(raw_event: String) -> Dictionary:
    # Process each line in the SSE event.
    var lines = raw_event.split("\n")
    var event_name = ""
    var data_str = ""
    for line in lines:
        line = line.strip_edges()
        if line.begins_with(EVENT_TAG):
            event_name = line.substr(EVENT_TAG.length(), line.length()).strip_edges()
        elif line.begins_with(DATA_TAG):
            # Concatenate data if there are multiple data lines.
            data_str += line.substr(DATA_TAG.length(), line.length()).strip_edges()
    if event_name == "":
        event_name = CONTINUE_INTERNAL
    var parsed_data = null
    if data_str != "":
        var json_parse = JSON.parse_string(data_str)
        parsed_data = json_parse
        if !json_parse:
            parsed_data = data_str  # Fallback to raw data if JSON parsing fails.
    return {"event": event_name, "data": parsed_data}

func _exit_tree():
    if httpclient:
        httpclient.close()

func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        if httpclient:
            httpclient.close()
        get_tree().quit()
