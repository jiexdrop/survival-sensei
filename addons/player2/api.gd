class_name Player2API

static func _get_headers(config : Player2APIConfig) -> Array[String]:
	var game_key = ProjectSettings.get_setting("player2/game_key")
	if !game_key or game_key.is_empty():
		game_key = "undefined_godot_project"
	var key = game_key# game_key.replace(" ", "_").replace(":", "_")
	return [
		"Content-Type: application/json; charset=utf-8",
		"Accept: application/json; charset=utf-8",
		"player2-game-key: " + key
	]

static func get_health(config : Player2APIConfig, on_complete : Callable, on_fail : Callable = Callable()):
	Player2WebHelper.request(config.endpoint_health, HTTPClient.Method.METHOD_GET, "", _get_headers(config),
	func(body, code):
		#var result = JsonClassConverter.json_to_class(Player2Schema.Health, JSON.parse_string(body))
		var result = JSON.parse_string(body)
		on_complete.call(result)
	,
	on_fail
	)

static func _alert_error_fail(config : Player2APIConfig, code : int, use_http_result : bool = false):
	if use_http_result:
		match (code):
			HTTPRequest.RESULT_SUCCESS:
				return
			HTTPRequest.RESULT_CANT_CONNECT:
				Player2ErrorHelper.send_error(config, "Cannot connect to the Player2 Launcher!")
			var other:
				Player2ErrorHelper.send_error(config, "Godot HttpResult Error Code " + str(other))
				pass
	match (code):
		401:
			Player2ErrorHelper.send_error(config, "User is not authenticated in the Player2 Launcher!")
		402:
			Player2ErrorHelper.send_error(config, "Insufficient credits to complete request.")
		500:
			Player2ErrorHelper.send_error(config, "Internal server error.")

static func chat(config : Player2APIConfig, request: Player2Schema.ChatCompletionRequest, on_complete: Callable, on_fail: Callable = Callable()) -> void:

	# Conditionally REMOVE if there are no tools/tool choice
	var json_req = JsonClassConverter.class_to_json(request)
	if !request.tools or request.tools.size() == 0:
		json_req.erase("tools")
		json_req.erase("tool_choice")
		for m : Dictionary in json_req["messages"]:
			m.erase("tool_call_id")
			m.erase("tool_calls")

	Player2WebHelper.request(config.endpoint_chat, HTTPClient.Method.METHOD_POST, json_req, _get_headers(config),
	func(body, code):
		if code == 429:
			# Too many requests, try again...
			print("too many requests, trying again...")
			Player2WebHelper.call_timeout(func():
				# Call ourselves again...
				chat(config, request, on_complete, on_fail)
				, config.request_too_much_delay_seconds)
			return
		if code != 200:
			print("chat fail!")
			print(code)
			_alert_error_fail(config, code)
			if on_fail:
				on_fail.call(code)
			return
		print("GOT RESPONSE with code " + str(code))
		print(body)
		#var result = JsonClassConverter.json_to_class(Player2Schema.ChatCompletionResponse, JSON.parse_string(body))
		var result = JSON.parse_string(body)
		on_complete.call(result)
	,
	func(code):
		print("chat fail!")
		print(code)
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)

static func tts_speak(config : Player2APIConfig, request : Player2Schema.TTSRequest,on_complete : Callable = Callable(), on_fail : Callable = Callable()) -> void:
	Player2WebHelper.request(config.endpoint_tts_speak, HTTPClient.Method.METHOD_POST, request, _get_headers(config),
	func(body, code):
		if code == 200:
			if on_complete:
				var result = JSON.parse_string(body)
				on_complete.call(result)
		else:
			_alert_error_fail(config, code),
	func(code):
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)

static func tts_stop(config : Player2APIConfig, on_fail : Callable = Callable()) -> void:
	Player2WebHelper.request(config.endpoint_tts_stop, HTTPClient.Method.METHOD_POST, "", _get_headers(config),
	func(body, code):
		_alert_error_fail(config, code),
	func(code):
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)

static func stt_start(config : Player2APIConfig, request : Player2Schema.STTStartRequest, on_fail : Callable = Callable()) -> void:
	Player2WebHelper.request(config.endpoint_stt_start, HTTPClient.Method.METHOD_POST, request, _get_headers(config),
	func(body, code):
		_alert_error_fail(config, code),
	func(code):
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)

static func stt_stop(config : Player2APIConfig, on_complete : Callable, on_fail : Callable = Callable()) -> void:
	Player2WebHelper.request(config.endpoint_stt_stop, HTTPClient.Method.METHOD_POST, "", _get_headers(config),
	func(body, code):
		if on_complete:
			on_complete.call(JSON.parse_string(body))
			_alert_error_fail(config, code),
	func(code):
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)

static func get_selected_characters(config : Player2APIConfig, on_complete : Callable, on_fail : Callable = Callable()) -> void:
	Player2WebHelper.request(config.endpoint_get_selected_characters, HTTPClient.Method.METHOD_GET, "", _get_headers(config),
	func(body, code):
		on_complete.call(JSON.parse_string(body))
		_alert_error_fail(config, code),
	func(code):
		_alert_error_fail(config, code, true)
		if on_fail:
			on_fail.call(code)
	)
