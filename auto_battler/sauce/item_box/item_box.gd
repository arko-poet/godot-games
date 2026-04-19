extends Control

@onready var inventory: Inventory = $"../Inventory"


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	inventory.remove_item(item)
	item.reparent(self)
	
	var offset: Vector2 = data["offset"]
	#for i in item.footprint_index:
		#offset = Vector2(-offset.y, offset.x)
	item.position = at_position - offset


func _on_combat_started(_combat_number: int) -> void:
	for c in get_children():
		if c is Item:
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_combat_finished() -> void:
	for c in get_children():
		if c is Item:
			c.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_inventory_item_removed(item: Item) -> void:
	item.reparent(self)
	item.position = -item.get_top_left_corner()
