extends Area2D

@export var player_2ainpc: Player2AINPC
@export var level_1: Level

@onready var fire: AnimatedSprite2D = $Fire


func _on_body_entered(body: Node2D) -> void:
	player_2ainpc.notify("The player started the fire! React with a message.")
	player_2ainpc.tts_ended.connect(level_1.win)
	fire.visible = true
