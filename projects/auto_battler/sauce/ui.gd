extends Control

@onready var inventory: Inventory = $Inventory


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("drop in ui")
	var dict: Dictionary
	if data is Dictionary:
		dict = data
	else:
		push_error("invalid data format")
		return
	
	var ic: InventoryComponent = dict.get("inventory_component", null)
	if ic is Item:
		if ic in inventory.get_children():
			inventory.remove_item(ic)
		ic.reparent(self)
		ic.position = at_position - dict["offset"]
		ic.move_to_front()
	else:
		inventory.remove_bag(ic)
		ic.clear_items()
		ic.reparent(self)
		ic.position = at_position - dict["offset"]
	
	ic.hide()
	ic.physical_item.stop_drag(ic.global_position)
