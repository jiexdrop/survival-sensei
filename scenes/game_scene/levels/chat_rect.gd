extends CanvasLayer

@export var player_2ainpc: Player2AINPC 
@export var text_edit: TextEdit
@export var speech_bubble: SpeechBubble 
@export var sensei_avatar: TextureRect

# Animation properties
@export var animation_duration: float = 0.3
@export var scale_amount: float = 0.95
@export var fade_duration: float = 0.2

var original_scale: Vector2
var tween: Tween

func _ready() -> void:
	text_edit.text_set.connect(_send_text)
	
	# Store original scale for animation
	original_scale = text_edit.scale
	
	# Connect the TextureRect to the SpeechBubble
	if speech_bubble and sensei_avatar:
		speech_bubble.set_sensei_avatar(sensei_avatar)
	
	text_edit.gui_input.connect(
		func(event : InputEvent):
			if event is InputEventKey:
				# Enter: submit shortcut
				if event.pressed and event.keycode == KEY_ENTER:
					text_edit.accept_event()
					_animate_text_send(text_edit.text)
	)
	
	player_2ainpc.chat_received.connect(speech_bubble.set_message)
	player_2ainpc.tts_began.connect(speech_bubble.play)

func _animate_text_send(text: String):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	# Scale down animation
	tween.tween_property(text_edit, "scale", original_scale * scale_amount, animation_duration * 0.5)
	tween.tween_property(text_edit, "scale", original_scale, animation_duration * 0.5).set_delay(animation_duration * 0.5)
	
	# Optional: Fade out slightly and back in
	tween.tween_property(text_edit, "modulate:a", 0.7, animation_duration * 0.3)
	tween.tween_property(text_edit, "modulate:a", 1.0, animation_duration * 0.7).set_delay(animation_duration * 0.3)
	
	# Clear text with a slight delay for visual feedback
	tween.tween_callback(func(): text_edit.text = "").set_delay(animation_duration * 0.2)
	
	# Send the text after animation completes
	tween.tween_callback(func(): _send_text(text)).set_delay(animation_duration)

func _send_text(text: String):
	print("Sending text to Player2: ", text)
	player_2ainpc.chat(text, "Player")
