class_name Hurtbox
extends Area2D

signal knockback(power: int, dir: Vector2)

@export var health: Health

func _ready() -> void:
	connect("area_entered", _on_area_entered)	

func _on_area_entered(area: Area2D):	
	health.apply_damage(1)
	knockback.emit(1, Vector2.RIGHT)
