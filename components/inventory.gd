class_name Inventory
extends Node

const _ITEM_ORDER: Array = ["tonic", "bullet", "bomba"]

var _items: Dictionary = {
	"tonic": 0,
	"bullet": 0,
	"bomba": 0
}

var _item_index: int = -1

func initialize(tonics: int, bullets: int, bombas: int) -> Dictionary:
	_items = {
		"tonic": tonics,
		"bullet": bullets,
		"bomba": bombas
	}
	
	_initialize_item_index()			
	return current_item()
	
func current_item() -> Dictionary:
	if _item_index == -1:
		return {"item": "none", "quantity": 0}
	else:
		var item = _ITEM_ORDER[_item_index]
		var quantity = _items[item]
		return {"item": item, "quantity": quantity}
	
func next_item() -> Dictionary:
	if _item_index == -1:
		_initialize_item_index()
	else:
		var i = 1
		while i <= _ITEM_ORDER.size():
			var index = (_item_index + i) % _ITEM_ORDER.size()
			var item = _ITEM_ORDER[index]
			if _items[item] > 0:
				_item_index = index
				break
	return current_item()
				
	
func _initialize_item_index() -> void:
	for i in _ITEM_ORDER.size():
		var item = _ITEM_ORDER[i]
		if _items[item] > 0:
			_item_index = i
			break
