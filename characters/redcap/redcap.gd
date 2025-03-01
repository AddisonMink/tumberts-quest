extends Creature

const WALK_SPEED = 200
const ATTACK_WINDUP_DURATION = 0.5
const ATTACK_COOLDOWN_DURATION = 0.5
const ATTACK_RANGE_TOLERANCE = 16
const ATTACK_RANGE = 16 * 8
const ATTACK_SPEED = 400
const ATTACK_LENGTH = 14
const ATTACK_BREADTH = 10
const ATTACK_OFFSET = 5

enum State {
	IDLE,
	WALKING,
	ATTACK_WINDUP,
	ATTACKING,
} 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: RedcapHitbox = $RedcapHitbox
@onready var player: Node2D = find_tumbert()

var state: State = State.IDLE
var facing: Facing.Facing = Facing.Facing.DOWN
var attack_windup_timer: Timer = null
var attack_cooldown_timer: Timer = null

func _ready() -> void:
	super._ready()	
	attack_windup_timer = make_timer(ATTACK_WINDUP_DURATION)
	attack_cooldown_timer = make_timer(ATTACK_COOLDOWN_DURATION)
	remove_child(hitbox)
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
	facing = Facing.facing_to(global_position, player.global_position)
	var target = Facing.facing_vector(facing) * -1 * ATTACK_RANGE + player.global_position			
	var diff_to_target = target - global_position
	
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
	hitbox.initialize(Facing.facing_vector(facing))
	add_child(hitbox)
	state = State.ATTACKING
	velocity = Facing.facing_vector(facing) * ATTACK_SPEED
	play_animation_facing("attack", facing)		
	
func update_attacking():
	if animated_sprite.frame_progress >= 1:
		remove_child(hitbox)
		attack_cooldown_timer.start()
		transition_to_idle()	

# UTIL
func make_timer(wait_time: float) -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = wait_time
	add_child(timer)
	return timer
