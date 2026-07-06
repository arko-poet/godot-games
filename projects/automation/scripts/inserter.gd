extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent

var direction := Vector2i(1, 0)

var world: World

func _on_building_component_timeout() -> void:
	var source_node := world.get_node_at_cell(building_component.center_cell - direction)
	
	var destination := building_component.center_cell + direction
	var destination_node := world.get_node_at_cell(destination)
	
	if destination_node is Item or source_node == null:
		return
	
	var item: Item
	if source_node is Item:
		item = source_node
	else:
		var bc: BuildingComponent = source_node.get_node(^"BuildingComponent")
		if not bc.has_stored_items():
			return
		item = bc.get_stored_item()
		world.add_child(item)
	
	if destination_node == null:
		print(destination)
		item.cell = destination
	else:
		var bc: BuildingComponent = destination_node.get_node(^"BuildingComponent")
		bc.store_item(item)
