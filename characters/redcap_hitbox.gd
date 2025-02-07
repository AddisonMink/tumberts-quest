class_name RedcapHitbox
extends Hitbox

const _LENGTH = 14.0
const _BREADTH = 10.0 

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _rec: RectangleShape2D = null

func _ready() -> void:
	_rec = _collision_shape.shape as RectangleShape2D

func initialize(dir: Vector2):
	if dir.x > 0: 	# Right
		_rec.size = Vector2(_LENGTH, _BREADTH)
		_collision_shape.position = Vector2(2, 3)
	elif dir.x < 0: # Left
		_rec.size = Vector2(_LENGTH, _BREADTH)
		_collision_shape.position = Vector2(-2, 3)
	elif dir.y > 0: # Down
		_rec.size = Vector2(_BREADTH, _LENGTH)
		_collision_shape.position = Vector2(0, 5)
	else:			# Up
		_rec.size = Vector2(_BREADTH, _LENGTH)
		_collision_shape.position = Vector2(0, 1)
