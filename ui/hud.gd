extends NinePatchRect

@onready var _hp_meter = $HPMeter
@onready var _item: AnimatedSprite2D = $Item
@onready var _item_count: Label = $ItemCount

func _ready() -> void:
	set_max_hp(5)
	set_hp(5)
	set_item("none", 0)

func set_hp(current: int) -> void:
	_hp_meter.current_hp = current

func set_max_hp(max_hp: int) -> void:
	_hp_meter.max_hp = max_hp

func set_item(name: String, quantity: int) -> void:
	
	match name:
		"tonic": 
			_item.play("tonic")
			_item_count.text = "x%d" % quantity
		"bomba": 
			_item.play("bomba")
			_item_count.text = "x%d" % quantity
		"bullet": 
			_item.play("bullet")
			_item_count.text = "x%d" % quantity
		_: 
			_item.play("empty")
			_item_count.text = ""
	
