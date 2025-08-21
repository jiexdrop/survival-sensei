extends Area2D

@onready var level_2: Level

func _ready() -> void:
	level_2 = get_parent().get_parent() as Level

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected carrot!")
		level_2.level_state.collected_carrots += 1
		GlobalState.save()
		queue_free()
