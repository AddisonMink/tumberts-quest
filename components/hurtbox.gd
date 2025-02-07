class_name Hurtbox
extends Area2D

const HIT_FLASH_DURATION = 0.1
const INVINCIBILITY_DURATION = 0.5

signal knockback(power: int, dir: Vector2)

@export var health: Health
@export var animated_sprite: AnimatedSprite2D
@export var blinker: Blinker

var active = true

func _ready() -> void:
	connect("area_entered", _on_area_entered)	

func _on_area_entered(area: Area2D):	
	if not active:
		return
	var hitbox = area as Hitbox
	if not hitbox:
		return

	health.apply_damage(hitbox.damage)
	knockback.emit(hitbox.knockback_power, hitbox.dir)

	var shader_material = animated_sprite.material as ShaderMaterial
	shader_material.set_shader_parameter("whiten", true)		
	await get_tree().create_timer(HIT_FLASH_DURATION).timeout
	shader_material.set_shader_parameter("whiten", false)	
	
	blinker.start_blinking(animated_sprite, INVINCIBILITY_DURATION)
	active = false
	await get_tree().create_timer(HIT_FLASH_DURATION).timeout
	active = true
