extends Area2D

var level_state : LevelState

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Collected wood!")
		level_state.collected_wood += 1
		GlobalState.save()
		queue_free()
