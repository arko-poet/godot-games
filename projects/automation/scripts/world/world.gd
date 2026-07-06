class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

var _item_and_building_coords: Dictionary[Vector2i, Node2D]

@onready var layers: TileMapLayers = %Layers


func _on_child_entered_tree(node: Node) -> void:
	if node is Item:
		node.item_moved.connect(_on_item_moved)


func register_building(building: Node2D) -> void:
	var building_component: BuildingComponent
	for c in building.get_children():
		if c is BuildingComponent:
			building_component = c
			break
		push_error("Building lacks a building component")
	
	var center_tile := _get_tile(building.position)
	var _building_radius = building_component.cell_radius
	for i in range(center_tile - _building_radius, center_tile + _building_radius + 1):
		for j in range(center_tile - _building_radius, center_tile + _building_radius + 1):
			var tile := Vector2i(i, j)
			_item_and_building_coords[tile] = building
			
			
func _on_item_moved(from: Vector2, to: Vector2) -> void:
	var from_tile := _get_tile(from)
	var to_tile := _get_tile(to)
	
	if not _is_cell_free(to_tile):
		push_error("Attempt to place item in occupied cell")
		return
	
	var item := _item_and_building_coords[from_tile]
	_item_and_building_coords.erase(from_tile)
	_item_and_building_coords[to_tile] = item


func _get_tile(coords: Vector2) -> Vector2i:
	return layers.resource_layer.local_to_map(coords)


func _is_cell_free(coords: Vector2i) -> bool:
	return coords not in _item_and_building_coords or _item_and_building_coords[coords] == null
