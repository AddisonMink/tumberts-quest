extends NinePatchRect

@onready var _hp_meter = $HPMeter

func set_hp(current: int) -> void:
	_hp_meter.current_hp = current

func set_max_hp(max: int) -> void:
	_hp_meter.max_hp = max
