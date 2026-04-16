extends Control

@onready var inventory: Inventory = $"../Inventory"


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	inventory.remove_item(item)
	item.reparent(self)
	item.position = _at_position - data["offset"]
