extends Area2D

@onready var level_2: Level
@export var pan: Pan


func _ready() -> void:
	level_2 = get_parent() as Level

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected Pan: ", level_2.level_state.has_pan)
		if level_2.level_state.collected_carrots >= 2 and pan.visible:
			pan.set_close()
		if level_2.level_state.has_pan:
			pan.visible = true
