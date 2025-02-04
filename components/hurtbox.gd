class_name Hurtbox
extends Area2D

signal knockback(power: int, dir: Vector2)

@export var health: Health

func _ready() -> void:
	connect("area_entered", _on_area_entered)	

func _on_area_entered(area: Area2D):	
	var hitbox = area as Hitbox
	if not hitbox:
		return

	health.apply_damage(hitbox.damage)
	knockback.emit(hitbox.knockback_power, hitbox.dir)
