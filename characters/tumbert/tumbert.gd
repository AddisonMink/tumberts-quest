extends Creature

enum State {
	IDLE,
	WALKING,
	ATTACKING,
} 

const _SWORD_SCENE = preload("res://characters/tumbert/player_sword.tscn")
const _WALK_SPEED = 250
const _SWORD_OFFSET_RIGHT = Vector2(100, 22) / 8
const _SWORD_OFFSET_DOWN = Vector2(0, 90) / 8

@onready var _attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var _idle_cooldown_timer: Timer = $IdleCooldownTimer

var _facing: Facing.Facing = Facing.Facing.DOWN
var _dir: Vector2 = Vector2(0,0)
var _sword: Hitbox = null
var _state = State.IDLE

func _ready() -> void:
	super._ready()
	_transition_to_idle()

func _process(_delta: float):
	if is_stunned():
		return
	match _state:
		State.IDLE: _update_idle()
		State.WALKING: _update_walking()
		State.ATTACKING: _update_attacking()

#################################################################
## STATE MACHINE												  ##
#################################################################
func _transition_to_idle():
	_state = State.IDLE
	play_animation_facing("idle", _facing)
	_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	_animated_sprite.pause()
	_idle_cooldown_timer.start()
	
func _update_idle():
	if Input.is_action_just_pressed("button1") and _attack_cooldown_timer.get_time_left() <= 0:
		_transition_to_attacking()
		return
	
	var new_dir = _input_vector()
	if not new_dir.is_zero_approx():
		_transition_to_walking(new_dir)
		return
		
	if _idle_cooldown_timer.get_time_left() <= 0:
		_animated_sprite.play()
		_idle_cooldown_timer.start()
			
	
func _transition_to_walking(new_dir: Vector2):
	if _state == State.IDLE or _vector_is_cardinal(new_dir):
		_facing = Facing.vector_facing(new_dir)	
		play_animation_facing("walk", _facing)
	_dir = new_dir
	_state = State.WALKING
	velocity = _dir * _WALK_SPEED
	
func _update_walking():
	if Input.is_action_just_pressed("button1") and _attack_cooldown_timer.get_time_left() <= 0:
		_transition_to_attacking()
	else:
		var new_dir = _input_vector()			
		if new_dir.is_zero_approx():
			_transition_to_idle()
		else:				
			_transition_to_walking(new_dir)
			
func _transition_to_attacking():
	var offset = (
		_SWORD_OFFSET_DOWN if _facing == Facing.Facing.DOWN
		else _SWORD_OFFSET_DOWN * Vector2(1, -1) if _facing == Facing.Facing.UP
		else _SWORD_OFFSET_RIGHT if _facing == Facing.Facing.RIGHT
		else _SWORD_OFFSET_RIGHT * Vector2(-1, 1)
	)
	
	velocity = Vector2.ZERO
	_state = State.ATTACKING
	_sword = _SWORD_SCENE.instantiate()
	add_child(_sword)
	_sword.initialize(_facing, offset)
	play_animation_facing("attack", _facing)
	
func _update_attacking():
	if _animated_sprite.frame_progress >= 1:
		_sword.queue_free()
		_transition_to_idle()
		_attack_cooldown_timer.start()
	
#################################################################
## UTIL														  ##
#################################################################
func _input_vector() -> Vector2:
	var dir = Vector2(0, 0)
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("left"):		
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	return dir.normalized()
	
func _vector_is_cardinal(dir: Vector2) -> bool:
	return dir.x == 0 and dir.y != 0 or dir.x != 0 and dir.y == 0
