extends Node

enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

static func facing_vector(facing: Facing) -> Vector2:
	match facing:
		Facing.UP: return Vector2.UP
		Facing.DOWN: return Vector2.DOWN
		Facing.LEFT: return Vector2.LEFT
		Facing.RIGHT: return Vector2.RIGHT
	return Vector2.ZERO
	
static func vector_facing(dir: Vector2) -> Facing:	
	if dir.x != 0 && dir.y == 0:
		return Facing.RIGHT if dir.x > 0 else Facing.LEFT
	else:
		return Facing.DOWN if dir.y > 0 else Facing.UP 
		
static func facing_to(from: Vector2, to: Vector2):
	var diff = to - from
	if abs(diff.y) >= abs(diff.x):
		return Facing.DOWN if diff.y > 0 else Facing.UP
	else:
		return Facing.RIGHT if diff.x > 0 else Facing.LEFT	
