extends Creature

const _BULLET_SCENE = preload("res://characters/scamp/scamp_bullet.tscn")

enum State {
	ASLEEP,
	WAKING,
	IDLE,
	ALIGNING,
	ATTACK_WINDUP,
	ATTACKING,
	FLEEING,
}

const _WAKE_DISTANCE = 1000
const _ALIGN_SPEED = 200
const _ALIGN_TOLERANCE = 10
const _FLEE_DISTANCE = 400

@onready var _wake_timer: Timer = $WakeTimer
@onready var _attack_windup_timer: Timer = $AttackWindupTimer
@onready var _attack_timer: Timer = $AttackTimer
@onready var _attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var _player: Creature = find_tumbert()

var _facing: Facing.Facing = Facing.Facing.DOWN
var _state: State

#################################################################
## PUBLIC													  ##
#################################################################

func reset() -> void:
	super.reset()
	_transition_to_asleep()

#################################################################
## READY AND PROCESS											  ##
#################################################################

func _ready() -> void:
	super._ready()
	_transition_to_asleep()
	
func _process(_delta: float) -> void:
	if is_stunned():
		return
		
	match _state:
		State.ASLEEP: _update_asleep()
		State.WAKING: _update_waking()
		State.IDLE: _update_idle()
		State.ALIGNING: _update_aligning()
		State.ATTACK_WINDUP: _update_attack_windup()
		State.ATTACKING: _update_attacking()
		State.FLEEING: _update_fleeing()
	
#################################################################
## STATE MACHINE												  ##
#################################################################

func _transition_to_asleep() -> void:
	_state = State.ASLEEP
	velocity = Vector2.ZERO
	_animated_sprite.play("sleep")
	
func _update_asleep() -> void:
	if not _player:
		return
		
	var dist = global_position.distance_to(_player.global_position)
	if dist <= _WAKE_DISTANCE:
		_transition_to_waking()
	
func _transition_to_waking() -> void:
	_state = State.WAKING
	_wake_timer.start()
	_animated_sprite.play("wake")
	
func _update_waking() -> void:
	if _wake_timer.get_time_left() <= 0:
		_transition_to_idle()

func _transition_to_idle() -> void:
	velocity = Vector2.ZERO
	if _player:
		_facing = Facing.facing_to(global_position, _player.global_position)
	play_animation_facing("idle", _facing)
	_state = State.IDLE
	
func _update_idle() -> void:
	var vec = _alignment_vector()
	if vec.length() < _ALIGN_TOLERANCE and _attack_cooldown_timer.time_left <= 0:		
		_transition_to_attack_windup()	
	elif _player and (_player.global_position - global_position).length() < _FLEE_DISTANCE:
		_transition_to_fleeing()
	elif vec.length() > _ALIGN_TOLERANCE:
		_transition_to_aligning()
	
func _transition_to_aligning() -> void:
	play_animation_facing("walk", _facing)
	_state = State.ALIGNING
	
func _update_aligning() -> void:
	var vec = _alignment_vector()
	if vec.length() < _ALIGN_TOLERANCE:		
		_transition_to_idle()
	else:
		velocity = vec.normalized() * _ALIGN_SPEED
		_facing = Facing.vector_facing(vec)
		play_animation_facing("walk", _facing)
		
func _transition_to_attack_windup() -> void:
	play_animation_facing("attack_windup", _facing)
	_attack_windup_timer.start()
	_state = State.ATTACK_WINDUP
	
func _update_attack_windup() -> void:
	if _attack_windup_timer.time_left <= 0:
		_transition_to_attacking()
		
func _transition_to_attacking() ->  void:
	var bullet = _BULLET_SCENE.instantiate()
	bullet.initialize(position, Facing.facing_vector(_facing))
	get_parent().add_child(bullet)
	play_animation_facing("attack", _facing)
	_attack_timer.start()
	_state = State.ATTACKING
	
func _update_attacking() -> void:
	if _attack_timer.time_left <= 0:
		_attack_cooldown_timer.start()
		_transition_to_idle()
		
func _transition_to_fleeing() -> void:
	_state = State.FLEEING
	_update_fleeing()
	
func _update_fleeing() -> void:
	var vec = _alignment_vector()
	var diff = global_position - _player.global_position
	if diff.length() > _FLEE_DISTANCE or vec.length() < _ALIGN_TOLERANCE and _attack_cooldown_timer.time_left <= 0:
		_transition_to_idle()
	else:
		_facing = Facing.facing_to(_player.global_position, global_position)
		play_animation_facing("walk", _facing)
		velocity = diff.normalized() * _ALIGN_SPEED
		
#################################################################
## UTIL														  ##
#################################################################
func _alignment_vector():
	if not _player:
		return Vector2.ZERO
	var diff = _player.global_position - global_position
	return Vector2(diff.x, 0) if abs(diff.x) < abs(diff.y) else Vector2(0, diff.y)
	
