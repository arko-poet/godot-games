class_name Inserter
extends Building

var world: World

@onready var sprite: Sprite2D = %Sprite
@onready var _production_timer: Timer = %ProductionTimer


func _on_production_timer_timeout() -> void:
	var direction := get_direction()

	var source_node := world.get_node_at_cell(center_cell - direction)

	var destination_node := world.get_node_at_cell(center_cell + direction)

	if source_node == null:
		return

	var item: Item
	if source_node is Belt:
		if source_node.stored_item:
			item = source_node.stored_item
	else:
		var storage: StorageComponent = source_node.get_node(^"Storage")
		if not storage.has_stored_items():
			return
		item = storage.get_stored_item()
		world.add_child(item)

	if not item:
		return

	if destination_node is Belt:
		if destination_node.stored_item == null:
			if source_node is Belt:
				source_node.stored_item = null
			destination_node.stored_item = item
			item.position = destination_node.position
	else:
		var storage: StorageComponent = destination_node.get_node(^"Storage")
		storage.store_item(item)
