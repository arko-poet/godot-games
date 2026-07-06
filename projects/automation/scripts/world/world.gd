class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

var _item_and_building_coords: Dictionary[Vector2i, Node2D]

@onready var layers: TileMapLayers = %Layers


func _on_child_entered_tree(node: Node) -> void:
	if node is Item:
		node.item_moved.connect(_on_item_moved)

func get_tile(coords: Vector2) -> Vector2i:
	return layers.resource_layer.local_to_map(coords)


func register_building(building: Node2D) -> void:
	var building_component := BuildingController.get_building_component(building)
	
	var center_tile := get_tile(building.position)
	var _building_radius = building_component.footprint_size
	for i in range(center_tile.x - _building_radius, center_tile.x + _building_radius + 1):
		for j in range(center_tile.y - _building_radius, center_tile.y + _building_radius + 1):
			var tile := Vector2i(i, j)
			if not is_cell_free(tile):
				push_error("Attempting to place building on occupied tile")
				return
			_item_and_building_coords[tile] = building


func is_cell_free(coords: Vector2i) -> bool:
	return coords not in _item_and_building_coords or _item_and_building_coords[coords] == null


func _on_item_moved(from: Vector2, to: Vector2) -> void:
	var from_tile := get_tile(from)
	var to_tile := get_tile(to)
	
	if not is_cell_free(to_tile):
		push_error("Attempt to place item in occupied cell")
		return
	
	var item := _item_and_building_coords[from_tile]
	_item_and_building_coords.erase(from_tile)
	_item_and_building_coords[to_tile] = item
