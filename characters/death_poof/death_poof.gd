extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

func initialize(pos: Vector2) -> void:
	position = pos
	_animated_sprite.animation_finished.connect(_on_animation_finished)
	_animated_sprite.play("poof")

func _on_animation_finished() -> void:
	queue_free()
