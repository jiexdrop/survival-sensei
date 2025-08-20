extends Area2D

@export var player_2ainpc: Player2AINPC
@export var level_1: Level

@onready var fire: AnimatedSprite2D = $Fire
@onready var fire_place: AnimatedSprite2D = $FirePlace

var level_state : LevelState

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	print("LEVEL STATE", level_state)

func _on_body_entered(body: Node2D) -> void:
	player_2ainpc.notify("The player started the fire! React with a message.")
	player_2ainpc.tts_ended.connect(level_1.win)
	fire.visible = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected Wood: ", level_state.collected_wood)
		if level_state.collected_wood >= 3:
			fire_place.visible = true
