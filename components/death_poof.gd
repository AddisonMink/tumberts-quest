extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:	
	animated_sprite.play("poof")


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
