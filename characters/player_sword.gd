extends Hitbox

const Facing = preload("res://scripts/facing.gd")

@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D

const LENGTH = 14
const BREADTH = 6
const RIGHT_OFFSET = Vector2(-4, 0)
const DOWN_OFFSET = Vector2(0, -4)

func _ready() -> void:
	if collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()		
		
func initialize(facing: Facing.Facing, offset: Vector2) -> void:
	match facing:
		Facing.Facing.UP:
			(collision_shape.shape as RectangleShape2D).size = Vector2(BREADTH, LENGTH)
			collision_shape.position = DOWN_OFFSET * -1
			animated_sprite.play("down")
			animated_sprite.flip_h = false
			animated_sprite.flip_v = true
			dir = Vector2.UP
		Facing.Facing.DOWN:
			(collision_shape.shape as RectangleShape2D).size = Vector2(BREADTH, LENGTH)
			collision_shape.position = DOWN_OFFSET
			animated_sprite.play("down")
			animated_sprite.flip_h = false
			animated_sprite.flip_v = false
			dir = Vector2.DOWN
		Facing.Facing.LEFT:
			(collision_shape.shape as RectangleShape2D).size = Vector2(LENGTH, BREADTH)
			collision_shape.position = RIGHT_OFFSET * -1
			animated_sprite.play("right")
			animated_sprite.flip_h = true
			animated_sprite.flip_v = false
			dir = Vector2.LEFT
		Facing.Facing.RIGHT:
			(collision_shape.shape as RectangleShape2D).size = Vector2(LENGTH, BREADTH)
			collision_shape.position = RIGHT_OFFSET
			animated_sprite.play("right")
			animated_sprite.flip_h = false
			animated_sprite.flip_v = false
			dir = Vector2.RIGHT
	position = position + offset
