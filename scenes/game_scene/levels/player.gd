extends CharacterBody2D

var move_input : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_input = Vector2.RIGHT * Input.get_axis("move_left", "move_right") + Vector2.UP * Input.get_axis("move_down", "move_up")
	if get_viewport().gui_get_focus_owner():
		move_input = Vector2.ZERO

func _process(delta: float) -> void:
	position += move_input
	move_and_slide()
