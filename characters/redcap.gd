extends CreatureBody

const Facing = preload("res://scripts/facing.gd")

const WALK_SPEED = 100

enum State {
	IDLE,
	WALKING,
} 

@export var player: CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var state: State = State.IDLE
var facing: Facing.Facing = Facing.Facing.DOWN

func _ready() -> void:
	super._ready()
	transitionToIdle()

func _process(delta: float) -> void:
	if(isStunned()):
		return		
	match state:
		State.IDLE: updateIdle()
		State.WALKING: updateWalking()

func transitionToIdle():
	state = State.IDLE
	velocity = Vector2.ZERO
	Facing.play_animation_facing(animated_sprite, "idle", facing)
	
func updateIdle():
	if not player:
		return
	
	transitionToWalking()

func transitionToWalking():
	state = State.WALKING
	updateWalking()
	
func updateWalking():
	velocity = (player.position - position).normalized() * WALK_SPEED
	facing = Facing.facing_to(position, player.position)
	Facing.play_animation_facing(animated_sprite, "walk", facing)
