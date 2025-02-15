extends Control

const _PIP_WIDTH = 7
const _PIP_MARGIN = 1
const _WHITE = Color(1, 1, 1, 1)
const _DARK = Color(0.5, 0.5, 0.5, 1)

@export var pip_texture: Texture

var max_hp: int:
	set(value):
		max_hp = value
		queue_redraw()
		
var current_hp: int:
	set(value):
		current_hp = value
		queue_redraw()
		

func _draw() -> void:
	for i in max_hp:
		var x = (_PIP_WIDTH + _PIP_MARGIN) * i
		var mod = _WHITE if i < current_hp else _DARK
		draw_texture(pip_texture, Vector2(x,0.0), mod)
