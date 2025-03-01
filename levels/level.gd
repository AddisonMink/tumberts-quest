extends Node2D

@onready var _tumbert = $Tumbert
@onready var _camera = $Camera2D
@onready var _screen_transition_animation_player = $Camera2D/ScreenTransitionAnimationPlayer
@onready var _hud = $Camera2D/HUD

var _coord: Vector2i = Vector2i(0, 0)
var _screen_dict: Dictionary

func _ready() -> void:
	for child in get_children():
		var screen = child as Screen
		if screen:
			screen.screen_exited.connect(_on_screen_transition)
			screen.stop()
			_screen_dict[screen.coordinate()] = screen
	
	_screen_dict[_coord].start()
		
func _on_screen_transition(coord: Vector2i, dir: Vector2i, size: Vector2) -> void:
	var old_screen = _screen_dict[_coord]
	old_screen.stop()
	
	_coord = coord + dir
	var new_screen: Screen = _screen_dict[_coord]
	
	_screen_transition_animation_player.play("fade_out")
	await  _screen_transition_animation_player.animation_finished
	
	_camera.position = new_screen.position
	if dir.y != 0:
		_tumbert.position += Vector2(dir) * 128.0
	
	_screen_transition_animation_player.play("fade_in")
	await  _screen_transition_animation_player.animation_finished
	
	new_screen.start()
