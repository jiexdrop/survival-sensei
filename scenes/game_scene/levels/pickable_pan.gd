extends Area2D

@onready var level_2: Level

func _ready() -> void:
	level_2 = get_parent() as Level

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		level_2.level_state.has_pan = true
		GlobalState.save()
		queue_free()
