class_name Hurtbox
extends Area2D

signal hit(damage: int, knockback_power: int, dir: Vector2)
signal invincibility_over

const _INVINCIBILITY_DURATION = 0.5

var _active = true

func _ready() -> void:
	connect("area_entered", _on_area_entered)		

func _on_area_entered(hitbox: Hitbox):		
	if not _active:
		return
		
	_active = false
	hit.emit(hitbox.damage, hitbox.knockback_power, hitbox.dir)
	await get_tree().create_timer(_INVINCIBILITY_DURATION).timeout
	_active = true
	invincibility_over.emit()
