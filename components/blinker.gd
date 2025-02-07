class_name Blinker
extends Node

@export var blink_object: Node2D

func start_blinking() -> void:	
	_blink_timer.start()	
	
func stop_blinking() -> void:
	_blink_timer.stop()
	blink_object.visible = true	

const _BLINK_TIME = 0.1

@onready var _blink_timer: Timer = Timer.new()
	
func _ready():
	_blink_timer.autostart = false
	_blink_timer.wait_time = _BLINK_TIME
	_blink_timer.timeout.connect(_on_blink)
	add_child(_blink_timer)

func _on_blink() -> void:	
	blink_object.visible = !blink_object.visible
