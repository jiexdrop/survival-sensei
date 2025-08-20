extends Area2D

@export var player_2ainpc: Player2AINPC

@onready var fire: AnimatedSprite2D = $Fire
@onready var fire_place: AnimatedSprite2D = $FirePlace
@onready var level_1: Level
@onready var stick_search: Node2D

func _ready() -> void:
	level_1 = get_parent() as Level
	stick_search = get_parent().find_child("StickSearch") as StickSearch
	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected Wood: ", level_1.level_state.collected_wood)
		if fire_place.visible and level_1.level_state.has_stick:
			fire.visible = true
			player_2ainpc.notify("The player lit up the fire.")
			player_2ainpc.tts_ended.connect(level_1.win)
		if level_1.level_state.collected_wood >= 3 and not fire_place.visible:
			fire_place.visible = true
			player_2ainpc.notify("The player collected enough wood and built a firepit.")
			player_2ainpc.tts_ended.connect(show_stick_search)

func show_stick_search():
	stick_search.visible = true
