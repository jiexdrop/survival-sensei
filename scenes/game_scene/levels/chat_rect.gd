extends CanvasLayer

@export var player_2ainpc: Player2AINPC 
@export var text_edit: TextEdit
@export var speech_bubble: SpeechBubble 
@export var sensei_avatar: TextureRect  # Add this export

func _ready() -> void:
	text_edit.text_set.connect(_send_text)
	
	# Connect the TextureRect to the SpeechBubble
	if speech_bubble and sensei_avatar:
		speech_bubble.set_sensei_avatar(sensei_avatar)
	
	text_edit.gui_input.connect(
		func(event : InputEvent):
			if event is InputEventKey:
				# Enter: submit shortcut
				if event.pressed and event.keycode == KEY_ENTER:
					text_edit.accept_event()
					_send_text(text_edit.text)
	)
	
	player_2ainpc.chat_received.connect(speech_bubble.set_message)
	player_2ainpc.tts_began.connect(speech_bubble.play)
	

func _send_text(text):
	print("Text: ", text)
	player_2ainpc.chat(text, "Player")
