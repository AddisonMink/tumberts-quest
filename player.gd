extends CharacterBody2D

const Facing = preload("res://scripts/facing.gd")

const SWORD_SCENE = preload("res://player_sword.tscn")

enum State {
	IDLE,
	WALKING,
	ATTACKING,
}

const SPEED = 250
const SWORD_OFFSET_RIGHT = Vector2(100, 22)
const SWORD_OFFSET_DOWN = Vector2(0, 90)

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_cooldown_timer = $AttackCooldownTimer

var facing = Facing.Facing.DOWN
var dir = Vector2(0,0)
var sword = null
var state = State.IDLE

func _ready() -> void:
	transition_to_idle()	

func _process(delta: float) -> void:
	match state:
		State.IDLE:			
			if can_attack():
				transition_to_attacking()
			else:
				var new_dir = input_vector()		
				if not new_dir.is_zero_approx():
					transition_to_walking(new_dir)
		State.WALKING:
			if can_attack():
				transition_to_attacking()
			else:
				var new_dir = input_vector()			
				if new_dir.is_zero_approx():
					transition_to_idle()
				else:				
					transition_to_walking(new_dir)
		State.ATTACKING:
			var done = animated_sprite.frame_progress >= 1
			if done:
				transition_from_attacking()
				transition_to_idle()
				
func _physics_process(delta):
	velocity = dir * SPEED			
	move_and_slide()
	
func can_attack() -> bool:
	return Input.is_action_just_pressed("button1") and attack_cooldown_timer.get_time_left() <= 0
				
func transition_to_idle():
	Facing.play_animation_facing(animated_sprite, "idle", facing)
	dir = Vector2.ZERO
	state = State.IDLE
			
func transition_to_walking(new_dir: Vector2):
	if state == State.IDLE or vector_is_cardinal(new_dir):
		facing = Facing.vector_facing(new_dir)	
		Facing.play_animation_facing(animated_sprite, "walk", facing)
	dir = new_dir
	state = State.WALKING
	
func transition_to_attacking():
	var offset = Vector2.ZERO
	match facing:
		Facing.Facing.UP:
			offset = SWORD_OFFSET_DOWN * Vector2(1, -1)
		Facing.Facing.DOWN:
			offset = SWORD_OFFSET_DOWN
		Facing.Facing.LEFT:
			offset = SWORD_OFFSET_RIGHT * Vector2(-1, 1)
		Facing.Facing.RIGHT:
			offset = SWORD_OFFSET_RIGHT
	
	state = State.ATTACKING
	dir = Vector2.ZERO
	sword = SWORD_SCENE.instantiate()	
	add_child(sword)
	sword.initialize(facing, offset)	
	Facing.play_animation_facing(animated_sprite, "attack", facing)
	
func transition_from_attacking() -> void:
	sword.queue_free()		
	attack_cooldown_timer.start()
	
func input_vector() -> Vector2:
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
	
func vector_is_cardinal(dir: Vector2) -> bool:
	return dir.x == 0 and dir.y != 0 or dir.x != 0 and dir.y == 0
		
	
