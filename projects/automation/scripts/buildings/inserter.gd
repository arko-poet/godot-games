class_name Inserter
extends Building

var world: World


func _on_production_timer_timeout() -> void:
	var direction := get_direction()

	var source_node := world.get_node_at_cell(center_cell - direction)
	var item := _take_item(source_node)
	if not item:
		return

	var target_node := world.get_node_at_cell(center_cell + direction)
	if not _pass_item(item, target_node):
		_refund_item(item, source_node)


func _take_item(source_node: Node) -> Item:
	if source_node == null:
		return null

	var item: Item
	if source_node is Belt and source_node.stored_item:
		item = source_node.stored_item
		source_node.stored_item = null
	else:
		var storage: StorageComponent = source_node.get_node(^"Storage")
		if not storage or not storage.has_stored_items():
			return null
		item = storage.get_stored_item()

	return item


func _pass_item(item: Item, target_node: Node) -> bool:
	if target_node == null:
		return false

	if target_node is Belt:
		if target_node.stored_item == null:
			target_node.stored_item = item
			item.position = target_node.position
			world.add_child(item)
		else:
			return false
	else:
		var storage: StorageComponent = target_node.get_node(^"Storage")
		return storage and storage.store_item(item)

	return true


func _refund_item(item: Item, source_node: Node) -> void:
	if source_node is Belt:
		source_node.stored_item = item
	else:
		var storage: StorageComponent = source_node.get_node(^"Storage")
		if storage:
			storage.store_item(item)
