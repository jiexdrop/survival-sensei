class_name Pan
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	set_default()

func set_default():
	animated_sprite_2d.play("default")

func set_close():
	animated_sprite_2d.play("close")

func set_shake():
	animated_sprite_2d.play("shake")

func set_open():
	animated_sprite_2d.play("open")

func set_cooking():
	animated_sprite_2d.play("close")
	animated_sprite_2d.frame = 3
	animated_sprite_2d.pause()
