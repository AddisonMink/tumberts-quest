extends Creature

const WALK_SPEED = 200
const ATTACK_WINDUP_DURATION = 0.25
const ATTACK_COOLDOWN_DURATION = 1
const ATTACK_RANGE_TOLERANCE = 16
const ATTACK_RANGE = 16 * 8
const ATTACK_SPEED = 400

enum State {
	IDLE,
	WALKING,
	ATTACK_WINDUP,
	ATTACKING,
} 

@export var player: CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: State = State.IDLE
var facing: Facing = Facing.DOWN
var attack_windup_timer: Timer = null
var attack_cooldown_timer: Timer = null


func _ready() -> void:
	super._ready()	
	attack_windup_timer = make_timer(ATTACK_WINDUP_DURATION)
	attack_cooldown_timer = make_timer(ATTACK_COOLDOWN_DURATION)
	transition_to_idle()

func _process(_delta: float) -> void:
	if(is_stunned()):
		return		
	match state:
		State.IDLE: update_idle()
		State.WALKING: update_walking()
		State.ATTACK_WINDUP: update_attack_windup()
		State.ATTACKING: update_attacking()

func transition_to_idle():
	state = State.IDLE
	velocity = Vector2.ZERO
	play_animation_facing("idle", facing)
	
func update_idle():
	if not player:
		return
	transition_to_walking()

func transition_to_walking():
	state = State.WALKING
	update_walking()
	
func update_walking():	
	facing = facing_to(position, player.position)
	var target = facing_vector(facing) * -1 * ATTACK_RANGE + player.position			
	var diff_to_target = target - position
	
	if attack_cooldown_timer.get_time_left() <= 0 and diff_to_target.length() <= ATTACK_RANGE_TOLERANCE:
		transition_to_attack_windup()
	else:
		velocity = diff_to_target.normalized() * WALK_SPEED		
		play_animation_facing("walk", facing)
	
func transition_to_attack_windup():
	state = State.ATTACK_WINDUP
	velocity = Vector2.ZERO
	attack_windup_timer.start()
	play_animation_facing("attack_windup", facing)	

func update_attack_windup():
	if attack_windup_timer.get_time_left() <= 0:
		transition_to_attacking()
		
func transition_to_attacking():
	state = State.ATTACKING
	velocity = facing_vector(facing) * ATTACK_SPEED
	play_animation_facing("attack", facing)		
	
func update_attacking():
	if animated_sprite.frame_progress >= 1:
		attack_cooldown_timer.start()
		transition_to_idle()	

# UTIL
func make_timer(wait_time: float) -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = wait_time
	add_child(timer)
	return timer
