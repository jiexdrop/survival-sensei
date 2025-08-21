class_name Pan
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	set_defaut()

func set_defaut():
	animated_sprite_2d.play("default")

func set_close():
	animated_sprite_2d.play("close")

func set_shake():
	animated_sprite_2d.play("shake")

func set_open():
	animated_sprite_2d.play("open")
