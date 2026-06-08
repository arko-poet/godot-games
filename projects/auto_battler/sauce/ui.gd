extends Control

@onready var inventory: Inventory = $Inventory


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not get_viewport().gui_is_drag_successful():
			# restore item visibility if drag fails
			for ic in get_children():
				if ic is InventoryComponent:
					ic.physical_item.switch()
			for ic in inventory.get_children():
				if ic is InventoryComponent:
					ic.show()


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void: 
	var data_dictionary: Dictionary
	if data is Dictionary:
		data_dictionary = data
	else:
		push_error("invalid data format")
		return
	
	var ic: InventoryComponent = data_dictionary.get("inventory_component", null)
	if ic is Item:
		if ic in inventory.get_children():
			inventory.remove_item(ic)
		ic.reparent(self)
		ic.position = at_position - data_dictionary["offset"]
		ic.move_to_front()
	else:
		inventory.remove_bag(ic)
		ic.clear_items()
		ic.reparent(self)
		ic.position = at_position - data_dictionary["offset"]
	
	ic.hide()
	ic.physical_item.stop_drag(ic.global_position)


func _on_inventory_component_removed(removed_component: InventoryComponent) -> void:
	removed_component.reparent(self)
	removed_component.physical_item.position = Main.COMPONENT_SPAW_POSITION
	removed_component.hide()
	removed_component.physical_item.switch()
	
