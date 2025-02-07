class_name Creature
extends CharacterBody2D

signal death(pos: Vector2)

@export var knockback_resist: int

func is_stunned() -> bool:
	return not _knockback_timer.is_stopped()
	
const _KNOCKBACK_SPEED = 1000.0
const _KNOCKBACK_UNIT = 1.0 / 16.0
const _HIT_FLASH_DURATION = 0.1

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _health: Health = $Health
@onready var _blinker: Blinker = $Blinker
var _knockback_timer: Timer = Timer.new()

func _ready():
	_knockback_timer.one_shot = true
	add_child(_knockback_timer)
	_knockback_timer.timeout.connect(_on_knockback_done)
	_hurtbox.hit.connect(_on_hit)
	_hurtbox.invincibility_over.connect(_on_invincibility_over)
	_health.die.connect(_on_die)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func _on_knockback_done() -> void:
	velocity = Vector2.ZERO
	
func _on_hit(damage: int, knockback_power: int, dir: Vector2) -> void:
	# Set knockback.
	var knockback_time = max(0, knockback_power - knockback_resist) * _KNOCKBACK_UNIT	
	if knockback_time > 0:
		velocity = _KNOCKBACK_SPEED * dir
		_knockback_timer.start(knockback_time)
		
	# Apply damage.
	_health.apply_damage(damage)
	
	# Flash white.
	(_animated_sprite.material as ShaderMaterial).set_shader_parameter("whiten", true)
	await get_tree().create_timer(_HIT_FLASH_DURATION).timeout
	(_animated_sprite.material as ShaderMaterial).set_shader_parameter("whiten", false)
	
	# Blink while invincible.
	_blinker.start_blinking()	
	
func _on_invincibility_over() -> void:
	_blinker.stop_blinking()	
	
func _on_die() -> void:
	death.emit(position)
	queue_free()

# Facing type and functions.
## Represents a facing that corresponds to a cardinal direction.
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
		
@warning_ignore("shadowed_variable_base_class")
func play_animation_facing(name: String, facing: Facing) -> void:
	match facing:
		Facing.UP:
			_animated_sprite.play(name + "_up")			
			_animated_sprite.flip_h = false
		Facing.DOWN:
			_animated_sprite.play(name + "_down")
			_animated_sprite.flip_h = false
		Facing.LEFT:			
			_animated_sprite.flip_h = true
			_animated_sprite.play(name + "_right")			
		Facing.RIGHT:
			_animated_sprite.play(name + "_right")
			_animated_sprite.flip_h = false		
