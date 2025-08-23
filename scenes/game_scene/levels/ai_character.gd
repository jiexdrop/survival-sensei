class_name AICharacter
extends CharacterBody2D

@export var speed: float = 100.0
@onready var player_2ainpc: Player2AINPC = $Player2AINPC

var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if target_position != Vector2.ZERO:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed

		if global_position.distance_to(target_position) < 5.0:
			velocity = Vector2.ZERO
			target_position = Vector2.ZERO

		move_and_slide()

func go_to(marker_name: String) -> void:
	print("Going to", marker_name)
	var positions_node = get_parent().get_node("Positions")
	if positions_node.has_node(marker_name):
		var marker: Marker2D = positions_node.get_node(marker_name)
		target_position = marker.global_position
	else:
		push_warning("No marker found: " + marker_name)
