class_name Blinker
extends Node

const BLINK_TIME = 0.1

@onready var blink_timer: Timer = Timer.new()
@onready var blink_duration_timer: Timer = Timer.new()

var blink_object: Node2D

func start_blinking(object: Node2D, duration: float) -> void:	
	blink_object = object
	blink_timer.start()
	blink_duration_timer.start(duration)

func _ready():
	blink_timer.autostart = false
	blink_timer.wait_time = BLINK_TIME
	blink_timer.timeout.connect(_on_blink)
	add_child(blink_timer)
		
	blink_duration_timer.autostart = false
	blink_duration_timer.one_shot = true
	blink_duration_timer.timeout.connect(_on_blink_timeout)
	add_child(blink_duration_timer)

func _on_blink() -> void:	
	blink_object.visible = !blink_object.visible
	
func _on_blink_timeout() -> void:

	blink_timer.stop()
	blink_object.visible = true	
