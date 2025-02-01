extends Node

## Represents a facing that corresponds to a cardinal direction.
enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

## Return the vector that corresponds to a facing.
## @facing - input
## Edge Case: Returns Vector2.ZERO if @facing is invalid.
static func facing_vector(facing: Facing) -> Vector2:
	match facing:
		Facing.UP: return Vector2.UP
		Facing.DOWN: return Vector2.DOWN
		Facing.LEFT: return Vector2.LEFT
		Facing.RIGHT: return Vector2.RIGHT
	return Vector2.ZERO

## Return the facing that corresponds to a vector.
## @dir - direction_vector
## Edge Case: Disregards x-component of diagonal vectors.
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
		
## Play an animation with a given facing.
## @animated_sprite
## @name - Root of animation name. Example: The name of animation "walk_left" is "walk".
## @facing 
## Assumes that animations are defined for "_up", "_right", and "_down".
@warning_ignore("shadowed_variable_base_class")
static func play_animation_facing(animated_sprite: AnimatedSprite2D, name: String, facing: Facing) -> void:
	match facing:
		Facing.UP:
			animated_sprite.play(name + "_up")			
			animated_sprite.flip_h = false
		Facing.DOWN:
			animated_sprite.play(name + "_down")
			animated_sprite.flip_h = false
		Facing.LEFT:			
			animated_sprite.flip_h = true
			animated_sprite.play(name + "_right")			
		Facing.RIGHT:
			animated_sprite.play(name + "_right")
			animated_sprite.flip_h = false		
