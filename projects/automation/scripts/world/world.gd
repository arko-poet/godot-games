class_name World
extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

var _cell_occupants: Dictionary[Vector2i, Node2D]

@onready var layers: TileMapLayers = %Layers


func get_node_at_cell(cell: Vector2i) -> Node2D:
	var cell_occupant = _cell_occupants.get(cell)
	if cell_occupant:
		return cell_occupant

	return null


func get_tile(coords: Vector2) -> Vector2i:
	return layers.resource_layer.local_to_map(coords)


func get_tile_position(coords: Vector2i) -> Vector2:
	return layers.resource_layer.map_to_local(coords)


func register_building(building: Building) -> void:
	var center_tile := get_tile(building.position)
	building.center_cell = center_tile
	var _building_radius = building.footprint_size
	for i in range(center_tile.x - _building_radius, center_tile.x + _building_radius + 1):
		for j in range(center_tile.y - _building_radius, center_tile.y + _building_radius + 1):
			var tile := Vector2i(i, j)
			if not is_cell_free(tile):
				push_error("Attempting to place building on occupied tile")
				return
			_cell_occupants[tile] = building

	if building is Belt:
		_register_belt(building)


func is_cell_free(coords: Vector2i) -> bool:
	return coords not in _cell_occupants or _cell_occupants[coords] == null


## adds belt to belt chain (linked list)
func _register_belt(belt: Belt) -> void:
	var destination_node := get_node_at_cell(belt.center_cell + belt.get_direction())
	if destination_node and destination_node is Belt:
		belt.next_belt = destination_node

	for direction in belt.DIRECTIONS:
		var source_node := get_node_at_cell(belt.center_cell + direction)
		if (
			source_node and source_node is Belt
			and get_node_at_cell(source_node.center_cell + source_node.get_direction()) == belt
		):
			source_node.next_belt = belt


func _on_child_entered_tree(node: Node) -> void:
	if node is Item:
		node.item_moved.connect(_on_item_moved)


func _on_item_moved(item: Item, from: Vector2i, to: Vector2i) -> void:
	if not (is_cell_free(to)):
		if get_node_at_cell(to) is Belt:
			var belt: Belt = get_node_at_cell(to)
			if belt.stored_item == null:
				belt.stored_item = item
				item.position = get_tile_position(to)
		else:
			push_error("Attempt to place item in occupied cell")
			return
	else:
		item.position = get_tile_position(to)
		_cell_occupants.erase(from)
		_cell_occupants[to] = item
