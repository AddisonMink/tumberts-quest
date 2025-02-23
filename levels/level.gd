extends Node2D

@onready var _camera = $Camera2D
@onready var _screen_transition_animation_player = $Camera2D/ScreenTransitionAnimationPlayer
@onready var _hud = $Camera2D/HUD
var _screen_dict: Dictionary

func _ready() -> void:
	for child in get_children():
		var screen = child as Screen
		if screen:
			screen.screen_exited.connect(_on_screen_transition)
			_screen_dict[screen.coordinate()] = screen
	print(_screen_dict)
		
func _on_screen_transition(coord: Vector2i, dir: Vector2i, size: Vector2) -> void:
	var new_coord = coord + dir
	var new_screen: Screen = _screen_dict[new_coord]
	
	_screen_transition_animation_player.play("fade_out")
	await  _screen_transition_animation_player.animation_finished
	
	_camera.position = new_screen.position
	
	_screen_transition_animation_player.play("fade_in")
	await  _screen_transition_animation_player.animation_finished
	
	new_screen.start()
