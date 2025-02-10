class_name GameScreen
extends Node

const _DEATH_POOF_SCENE = preload("res://characters/death_poof/death_poof.tscn")

func _ready() -> void:	
	for child in get_children():
		var creature = child as Creature
		if creature:
			creature.death.connect(_on_creature_death)

func _on_creature_death(pos: Vector2) -> void:
	var death_poof = _DEATH_POOF_SCENE.instantiate()
	add_child(death_poof)
	death_poof.initialize(pos)
	
