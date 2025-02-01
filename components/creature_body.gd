class_name CreatureBody
extends CharacterBody2D

const KNOCKBACK_SPEED = 200
const KNOCKBACK_UNIT = KNOCKBACK_SPEED

@export var knockback_resist: int

@onready var hurtbox: Hurtbox = $Hurtbox

var knockback_timer: Timer = Timer.new()

func _ready():
	print("READY")
	knockback_timer.one_shot = true
	add_child(knockback_timer)
	hurtbox.knockback.connect(_on_knockback)
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func isStunned() -> bool:
	return not knockback_timer.is_stopped()
	
func _on_knockback(power: int, dir: Vector2) -> void:
	print("received knockback")
	var knockback_time = 10
	velocity = KNOCKBACK_SPEED * dir
	knockback_timer.wait_time = knockback_time
	knockback_timer.start()
