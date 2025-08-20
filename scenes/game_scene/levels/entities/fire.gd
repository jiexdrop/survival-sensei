extends Area2D

@export var player_2ainpc: Player2AINPC

@onready var fire: AnimatedSprite2D = $Fire
@onready var fire_place: AnimatedSprite2D = $FirePlace
@onready var level_1: Level

func _ready() -> void:
	level_1 = get_parent() as Level
	
func _on_body_entered(body: Node2D) -> void:
	player_2ainpc.notify("The player started the fire! React with a message.")
	player_2ainpc.tts_ended.connect(level_1.win)
	fire.visible = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected Wood: ", level_1.level_state.collected_wood)
		if level_1.level_state.collected_wood >= 3:
			fire_place.visible = true
