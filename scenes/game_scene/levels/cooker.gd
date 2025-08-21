extends Area2D

@onready var level_2: Level
@export var pan: Pan
@export var player_2ainpc: Player2AINPC
@onready var shake_timer: Timer = $ShakeTimer

var should_shake : bool = false

func _ready() -> void:
	level_2 = get_parent() as Level

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not should_shake:
			pan.set_defaut()
		if should_shake:
			pan.set_shake()
			player_2ainpc.notify("The player is shaking the pan.")
			should_shake = false
		if level_2.level_state.collected_carrots >= 3 and pan.visible and not should_shake:
			print("Cooking carrots: ", level_2.level_state.has_pan)
			player_2ainpc.notify("The player puts the carrots on the pan.")
			pan.set_close()
			shake_timer.start()
		if level_2.level_state.has_pan and not should_shake:
			print("Collected Pan: ", level_2.level_state.has_pan)
			player_2ainpc.notify("The player has collected the pan and put it over the cooker.")
			pan.visible = true


func _on_shake_timer_timeout() -> void:
	should_shake = true
