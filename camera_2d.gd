extends Camera2D

const _OFFSET: Vector2i = Vector2i(0, 128)

@export var _player: Creature
@onready var _size: Vector2i = Vector2i(get_viewport_rect().size) - _OFFSET

func _ready() -> void:
	_update_position()

func _process(delta: float) -> void:
	_update_position()

func _update_position() -> void:
	var current_cell: Vector2i = Vector2i(_player.global_position) / _size
	global_position = current_cell * _size - _OFFSET
