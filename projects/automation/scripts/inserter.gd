extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent

var world: World


func _on_building_component_timeout() -> void:
	var direction := _get_direction()
	
	var source_node := world.get_node_at_cell(building_component.center_cell - direction)
	
	var destination := building_component.center_cell + direction
	var destination_node := world.get_node_at_cell(destination)
	
	if destination_node is Item or source_node == null:
		return
	
	var item: Item
	if source_node is Item:
		item = source_node
	else:
		var storage: StorageComponent = source_node.get_node(^"Storage")
		if not storage.has_stored_items():
			return
		item = storage.get_stored_item()
		world.add_child(item)
	
	if destination_node == null:
		print(destination)
		item.cell = destination
	else:
		var bc: BuildingComponent = destination_node.get_node(^"BuildingComponent")
		bc.store_item(item)


func _get_direction() -> Vector2i:
	var rotation_count := int(rotation / (TAU / 4.0))
	match rotation_count:
		0:
			return Vector2i.RIGHT
		1:
			return Vector2i.DOWN
		2:
			return Vector2i.LEFT
		3:
			return Vector2i.UP
		_:
			push_error("Invalid inserter direction")
			return Vector2i.RIGHT
