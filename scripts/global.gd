extends Node

enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func facing_vector(f: Facing) -> Vector2:
	match f:
		Facing.UP: return Vector2.UP
		Facing.DOWN: return Vector2.DOWN
		Facing.LEFT: return Vector2.LEFT
		Facing.RIGHT: return Vector2.RIGHT
	return Vector2.ZERO
