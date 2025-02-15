class_name Health
extends Node

signal die

@export var health: int
@export var max_health: int

func apply_damage(amount: int):
	health -= amount
	if health <= 0:
		die.emit()
