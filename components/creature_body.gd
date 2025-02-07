class_name CreatureBody
extends CharacterBody2D

signal death(pos: Vector2)

const KNOCKBACK_SPEED = 1000
const KNOCKBACK_UNIT = 1.0 / 16.0

@export var knockback_resist: int

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health: Health = $Health

var knockback_timer: Timer = Timer.new()

func _ready():
	knockback_timer.one_shot = true
	add_child(knockback_timer)
	hurtbox.knockback.connect(_on_knockback)
	knockback_timer.timeout.connect(_on_knockback_done)
	health.die.connect(_on_die)
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func isStunned() -> bool:
	return not knockback_timer.is_stopped()
	
func _on_knockback(power: int, dir: Vector2) -> void:
	var knockback_time = max(0, power - knockback_resist) * KNOCKBACK_UNIT
	if knockback_time > 0:
		velocity = KNOCKBACK_SPEED * dir
		knockback_timer.start(knockback_time)
	
func _on_knockback_done() -> void:
	velocity = Vector2.ZERO
	
func _on_die() -> void:
	death.emit(position)
	queue_free()
