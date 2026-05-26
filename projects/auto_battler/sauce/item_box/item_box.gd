## DEPRECATED, it was just used for initial testing
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
	
	var ic: InventoryComponent = dict.get("inventory_component", null)
	if ic is Item:
		inventory.remove_item(ic)
		ic.reparent(self)
		ic.position = at_position - dict["offset"]
		ic.move_to_front()
	else:
		inventory.remove_bag(ic)
		ic.clear_items()
		ic.reparent(self)
		ic.position = at_position - dict["offset"]


func _on_combat_started(_combat_number: int) -> void:
	for c in get_children():
		var item := c as Item
		if item != null:
			item.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_combat_finished() -> void:
	for c in get_children():
		var item := c as Item
		if item != null:
			item.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_inventory_item_removed(item: Item) -> void:
	item.reparent(self)
	item.position = -item.get_top_left_corner()


func _on_inventory_bag_removed(bag: Bag) -> void:
	bag.reparent(self)
	bag.position = -bag.get_top_left_corner()
