class_name Creature
extends CharacterBody2D

const Facing = preload("res://scripts/facing.gd")

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
	
func _physics_process(_delta: float) -> void:
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
	
func find_tumbert() -> Node2D:
	var tumberts =  get_tree().get_nodes_in_group("player")
	return tumberts[0] if tumberts.size() > 0 else null
		
@warning_ignore("shadowed_variable_base_class")
func play_animation_facing(name: String, facing: Facing.Facing) -> void:
	match facing:
		Facing.Facing.UP:
			_animated_sprite.play(name + "_up")			
			_animated_sprite.flip_h = false
		Facing.Facing.DOWN:
			_animated_sprite.play(name + "_down")
			_animated_sprite.flip_h = false
		Facing.Facing.LEFT:			
			_animated_sprite.flip_h = true
			_animated_sprite.play(name + "_right")			
		Facing.Facing.RIGHT:
			_animated_sprite.play(name + "_right")
			_animated_sprite.flip_h = false		
