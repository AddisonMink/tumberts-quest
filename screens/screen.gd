extends Node

@onready var hud = $HUD
@onready var tumbert = $Tumbert

func _ready() -> void:
	hud.set_max_hp(tumbert.get_max_health())
	hud.set_hp(tumbert.get_current_health())

func _process(_delta: float) -> void:
	if tumbert:
		hud.set_hp(tumbert.get_current_health())
