class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

var _cell_occupants: Dictionary[Vector2i, Node2D]

@onready var layers: TileMapLayers = %Layers


func _on_child_entered_tree(node: Node) -> void:
	if node is Item:
		node.item_moved.connect(_on_item_moved)


func get_node_at_cell(cell: Vector2i) -> Node2D:
	return _cell_occupants.get(cell)


func get_tile(coords: Vector2) -> Vector2i:
	return layers.resource_layer.local_to_map(coords)


func get_tile_position(coords: Vector2i) -> Vector2:
	return layers.resource_layer.map_to_local(coords)

func register_building(building: Node2D) -> void:
	var building_component: BuildingComponent = building.get_node(^"BuildingComponent")
	
	var center_tile := get_tile(building.position)
	building_component.center_cell = center_tile
	var _building_radius = building_component.footprint_size
	for i in range(center_tile.x - _building_radius, center_tile.x + _building_radius + 1):
		for j in range(center_tile.y - _building_radius, center_tile.y + _building_radius + 1):
			var tile := Vector2i(i, j)
			if not is_cell_free(tile):
				push_error("Attempting to place building on occupied tile")
				return
			_cell_occupants[tile] = building


func is_cell_free(coords: Vector2i) -> bool:
	return coords not in _cell_occupants or _cell_occupants[coords] == null


func _on_item_moved(item: Item, from: Vector2i, to: Vector2i) -> void:
	print("XD")
	if not is_cell_free(to):
		push_error("Attempt to place item in occupied cell")
		return
		
	print(item.position)
	item.position = get_tile_position(to)
	print(item.position)
	_cell_occupants.erase(from)
	_cell_occupants[to] = item
