class_name Health
extends Node

signal die

@export var health: int

func apply_damage(amount: int):
	print("Took %d damage." % amount)
	health -= amount
	if health <= 0:
		die.emit()
