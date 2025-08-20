extends Area2D

@onready var level_1: Level

func _ready() -> void:
	level_1 = get_parent() as Level

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected wood!")
		level_1.level_state.collected_wood += 1
		GlobalState.save()
		queue_free()
