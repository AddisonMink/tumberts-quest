extends CharacterBody2D

const SWORD_SCENE = preload("res://player_sword.tscn")

enum State {
	IDLE,
	WALKING,
	ATTACKING,
}

enum Facing {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const SPEED = 250
const SWORD_OFFSET_RIGHT = Vector2(100, 22)
const SWORD_OFFSET_DOWN = Vector2(0, 100)

@onready var animated_sprite = $AnimatedSprite2D
var facing = Facing.DOWN
var dir = Vector2(0,0)
var sword = null
var state = State.IDLE

func _ready() -> void:
	facing = Facing.DOWN	
	transition_to_idle()	

func _process(delta: float) -> void:
	match state:
		State.IDLE:			
			if Input.is_action_just_pressed("button1"):
				transition_to_attacking()
			var new_dir = input_vector()		
			if not new_dir.is_zero_approx():
				transition_to_walking(new_dir)
		State.WALKING:
			if Input.is_action_just_pressed("button1"):
				transition_to_attacking()
			var new_dir = input_vector()			
			if new_dir.is_zero_approx():
				transition_to_idle()
			else:				
				transition_to_walking(new_dir)
		State.ATTACKING:
			pass
				
func _physics_process(delta):
	velocity = dir * SPEED			
	move_and_slide()
				
func transition_to_idle():
	set_animation("idle", facing)
	dir = Vector2.ZERO
	state = State.IDLE
			
func transition_to_walking(new_dir: Vector2):
	if state == State.IDLE or vector_is_cardinal(new_dir):
		facing = vector_facing(new_dir)	
		set_animation("walk", facing)
	dir = new_dir
	state = State.WALKING
	
func transition_to_attacking():
	var offset = Vector2.ZERO
	match facing:
		Facing.UP:
			offset = SWORD_OFFSET_DOWN * Vector2(1, -1)
		Facing.DOWN:
			offset = SWORD_OFFSET_DOWN
		Facing.LEFT:
			offset = SWORD_OFFSET_RIGHT * Vector2(-1, 1)
		Facing.RIGHT:
			offset = SWORD_OFFSET_RIGHT
	
	sword = SWORD_SCENE.instantiate()	
	add_child(sword)
	sword.initialize(facing)	
	sword.position = sword.position + offset
	
func set_animation(type: String, dir: Facing) -> void:
	match dir:
		Facing.UP:
			animated_sprite.play(type + "_up")			
			animated_sprite.flip_h = false
		Facing.DOWN:
			animated_sprite.play(type + "_down")
			animated_sprite.flip_h = false
		Facing.LEFT:			
			animated_sprite.flip_h = true
			animated_sprite.play(type + "_right")			
		Facing.RIGHT:
			animated_sprite.play(type + "_right")
			animated_sprite.flip_h = false					
	
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
	
func vector_facing(dir: Vector2) -> Facing:
	if dir.x != 0 && dir.y == 0:
		return Facing.RIGHT if dir.x > 0 else Facing.LEFT
	if dir.x == 0 && dir.y != 0:
		return Facing.DOWN if dir.y > 0 else Facing.UP
	if dir.x != 0 && dir.y != 0:
		return Facing.DOWN if dir.y > 0 else Facing.UP
	return -1
	
func vector_is_cardinal(dir: Vector2) -> bool:
	return dir.x == 0 and dir.y != 0 or dir.x != 0 and dir.y == 0
		
	
