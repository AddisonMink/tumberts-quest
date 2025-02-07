extends Node2D

const DEATH_POOF_SCENE = preload("res://components/death_poof.tscn")

func _on_redcap_death(pos: Vector2) -> void:
	var death_poof = DEATH_POOF_SCENE.instantiate()	
	death_poof.position = pos
	add_child(death_poof)	
