class_name Health
extends Node

signal die

@export var health: int

func apply_damage(amount: int):
	health -= amount
	if health <= 0:
		die.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
