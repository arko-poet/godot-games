extends Control

@onready var inventory: Inventory = $"../Inventory"


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var dict: Dictionary
	if data is Dictionary:
		dict = data
	else:
		push_error("invalid data format")
		return
	
	var item: Item = dict.get("item", null)
	if item:
		inventory.remove_item(item)
		item.reparent(self)
		item.position = at_position - dict["offset"]
	else:
		var bag: Bag = dict["bag"]
		bag.reparent(self)
		bag.position = at_position - dict["offset"]


func _on_combat_started(_combat_number: int) -> void:
	for c in get_children():
		var item := c as Item
		if item != null:
			item.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_combat_finished() -> void:
	for c in get_children():
		var item := c as Item
		if item != null:
			item.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_inventory_item_removed(item: Item) -> void:
	item.reparent(self)
	item.position = -item.get_top_left_corner()


func _on_inventory_bag_removed(bag: Bag) -> void:
	bag.reparent(self)
	bag.position = Vector2.ZERO
