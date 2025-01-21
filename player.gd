extends Area2D

enum State {
	IDLE,
	WALKING
}

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const SPEED = 250

@onready var animated_sprite = $AnimatedSprite2D
var state = State.IDLE
var facing = Direction.DOWN


func _ready() -> void:
	position = Vector2(8,8)
	facing = Direction.DOWN
	transition_to_idle()	

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			var dir = input_direction()
			if dir != -1:
				transition_to_walking(dir)
		State.WALKING:
			var dir = input_direction()
			if dir == -1:
				transition_to_idle()
			elif dir != facing:
				transition_to_walking(dir)
				
func _physics_process(delta):
	if state == State.WALKING:
		move(facing, delta)		
				
func transition_to_idle():
	set_animation("idle", facing)
	state = State.IDLE
			
func transition_to_walking(dir: Direction):
	set_animation("walk", dir)
	facing = dir
	state = State.WALKING
	
func set_animation(type: String, dir: Direction) -> void:
	match dir:
		Direction.UP:
			animated_sprite.play(type + "_up")			
			animated_sprite.flip_h = false
		Direction.DOWN:
			animated_sprite.play(type + "_down")
			animated_sprite.flip_h = false
		Direction.LEFT:			
			animated_sprite.flip_h = true
			animated_sprite.play(type + "_right")			
		Direction.RIGHT:
			animated_sprite.play(type + "_right")
			animated_sprite.flip_h = false					
			
func move(dir: Direction, delta: float) -> void:
	var dirVec = Vector2(0,0)
	match dir:
		Direction.UP:
			dirVec = Vector2(0,-1)
		Direction.DOWN:
			dirVec = Vector2(0,1)
		Direction.LEFT:
			dirVec = Vector2(-1,0)
		Direction.RIGHT:
			dirVec = Vector2(1,0)
	position += dirVec * SPEED * delta

func input_direction() -> Direction:	
	if Input.is_action_pressed("down"):
		return Direction.DOWN
	if Input.is_action_pressed("up"):
		return Direction.UP
	if Input.is_action_pressed("left"):		
		return Direction.LEFT
	if Input.is_action_pressed("right"):
		return Direction.RIGHT	
	return -1
