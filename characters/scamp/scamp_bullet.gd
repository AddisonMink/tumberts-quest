extends Hitbox

const _SPEED = 800.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func initialize(pos: Vector2, direction: Vector2) -> void:
	dir = direction
	position = pos
	
func _process(delta: float) -> void:
	position += dir * _SPEED * delta


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free() # Replace with function body.


func _on_body_entered(_body: Node2D) -> void:
	animated_sprite.play("bullet_ping")
	dir = Vector2.ZERO
