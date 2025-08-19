extends ColorRect


@export var player_2ainpc: Player2AINPC 
@export var text_edit: TextEdit
@export var speech_bubble: SpeechBubble 

func _ready() -> void:
	text_edit.text_set.connect(_send_text)
	
	text_edit.gui_input.connect(
		func(event : InputEvent):
			if event is InputEventKey:
				# Enter: submit shortcut
				if event.pressed and event.keycode == KEY_ENTER:
					text_edit.accept_event()
					_send_text(text_edit.text)
	)
	
	player_2ainpc.chat_received.connect(speech_bubble.play)
	

func _send_text(text):
	print("Text: ", text)
	player_2ainpc.chat(text, "Player")
	
