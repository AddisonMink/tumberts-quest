class_name Screen
extends Area2D

signal screen_exited(coord: Vector2i, dir: Vector2i, size: Vector2)


const _SIZE: Vector2 = Vector2(1408, 1152)

@onready var _shape = $CollisionShape2D.shape as RectangleShape2D
@onready var _coordinate: Vector2i = Vector2i(position / _shape.size)
var _persistent_npcs: Array = []
var _need_to_reset: bool = false			

#################################################################
## PUBLIC METHODS											  ##
#################################################################

func coordinate() -> Vector2i:
	return _coordinate

func start() -> void:
	if _need_to_reset:
		call_deferred("_reset_persistent_npcs")

#################################################################
## SIGNAL HANDLERS											  ##
#################################################################

func _on_body_exited(body: Node2D) -> void:
	call_deferred("_clean_up_npcs")
	var dir = _direction_vector(body.global_position)
	screen_exited.emit(_coordinate, dir, _SIZE)
		
#################################################################
## LOGIC														  ##
#################################################################
	
func _direction_vector(pos: Vector2) -> Vector2i:
	var dx = (
		-1 if pos.x <= global_position.x
		else 1 if (pos.x - global_position.x) > _shape.size.x
		else 0
	)
	
	var dy = (
		-1 if pos.y <= global_position.y
		else 1 if (pos.y - global_position.y) > _shape.size.y
		else 0
	)		
	
	return Vector2i(dx, dy)
	
func _find_npcs():
	var npcs = []	
	for child in find_children("*", "", true, false):
		if child.is_in_group("npc"):
			npcs.append(child)
	return npcs
	
func _clean_up_npcs() -> void:
	for npc in _find_npcs():
		if npc.is_in_group("persistent"):	
			_persistent_npcs.append(npc)		
			remove_child(npc)
		else:
			npc.queue_free()
	_need_to_reset = true
		
func _reset_persistent_npcs() -> void:
	for npc in _persistent_npcs:
		add_child(npc)
		npc.reset()
	_persistent_npcs.clear()
	_need_to_reset = false
