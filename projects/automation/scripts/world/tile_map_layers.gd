class_name TileMapLayers
extends Node2D

signal resource_hovered(resource: ResourceNode)
signal resource_collected(type: Resources.Type, quantity: int)
signal chunk_generated(chunk: Vector2i)

const _RESOURCE_THRESHOLD := -0.75
const _CELLULAR_NOISE_THRESHOLD := -0.4
const _DEFAULT_CHUNK_GENERATION_RANGE := 9

## determines where resources are placed
var resource_cluster_generator := preload("res://resources/resource_clusters.tres")
## determines which resource to place in a region
var cellular_noise_value_generator := preload("res://resources/cellular_noise_value.tres")
## extra noise filter to make sure resources don't appear on boundaries of regions
var cellular_noise_distance_generator := preload("res://resources/cellular_noise_distance.tres")

## cellular_noise_value is same in each region, and each region maps to resource
var noise_to_resource: Dictionary[float, Resources.Type]
var _drawn_chunks: Array[Vector2i]
var _resource_nodes: Dictionary[Vector2i, ResourceNode]
var _hovered_coords: Vector2i
var _chunk_generation_range := _DEFAULT_CHUNK_GENERATION_RANGE:
	set(value):
		_chunk_generation_range = value
		_generate_chunks()
var _current_chunk := Vector2.ZERO:
	set(value):
		_current_chunk = value
		_generate_chunks()

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer


func _ready() -> void:
	var seed := randi()
	seed(seed)
	resource_cluster_generator.seed = seed
	cellular_noise_value_generator.seed = seed
	cellular_noise_distance_generator.seed = seed
	_generate_chunks()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var coords := resource_layer.local_to_map(get_local_mouse_position())
		if coords not in _resource_nodes:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			_hovered_coords = Vector2i.MIN
			resource_hovered.emit(null)
		elif coords != _hovered_coords:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			_hovered_coords = coords
			resource_hovered.emit(_resource_nodes[coords])
	elif (
		event is InputEventMouseButton and event.is_pressed()
		and _hovered_coords != Vector2i.MIN and event.button_index == MOUSE_BUTTON_LEFT
	):
		var resource_node := _resource_nodes[_hovered_coords]
		if resource_node.quantity > 0:
			resource_collected.emit(resource_node.resource_type, resource_node.mine())


func get_resource_nodes(location: Vector2, tile_range: int) -> Array[ResourceNode]:
	var center_tile := resource_layer.local_to_map(location)
	var resource_nodes: Array[ResourceNode]

	for i in range(-tile_range, tile_range + 1):
		for j in range(-tile_range, tile_range + 1):
			var tile := center_tile + Vector2i(i, j)
			if _resource_nodes.has(tile):
				resource_nodes.append(_resource_nodes[tile])

	return resource_nodes

## deprecated
func determine_resource_type(coords: Vector2i) -> Resources.Type:
	var noise := cellular_noise_value_generator.get_noise_2d(coords.x, coords.y)
	if noise in noise_to_resource:
		return noise_to_resource[noise]

	var resource := Resources.get_random_ore()
	noise_to_resource[noise] = resource
	return resource


func _generate_chunks() -> void:
	for x in range(
		_current_chunk.x - _chunk_generation_range,
		_current_chunk.x + _chunk_generation_range + 1,
	):
		for y in range(
			_current_chunk.y - _chunk_generation_range,
			_current_chunk.y + _chunk_generation_range + 1,
		):
			var chunk := Vector2i(x, y)
			if chunk not in _drawn_chunks:
				_generate_chunk(chunk)
				_drawn_chunks.append(chunk)


func _generate_chunk(chunk: Vector2i) -> void:
	var chunk_size := World.CHUNK_SIZE
	for x in chunk_size:
		for y in chunk_size:
			var coords := Vector2i(x + chunk.x * chunk_size, y + chunk.y * chunk_size)

			terrain_layer.set_cell(coords, 0, Vector2.ZERO)

			var noise := resource_cluster_generator.get_noise_2d(coords.x, coords.y)

			var noise2 := cellular_noise_distance_generator.get_noise_2d(coords.x, coords.y)
			if noise2 > _CELLULAR_NOISE_THRESHOLD:
				continue

			if noise <= _RESOURCE_THRESHOLD:
				var resource_type := _determine_resource_type(coords)
				var resource_node := ResourceNode.new(resource_type)
				_resource_nodes[coords] = resource_node
				resource_node.depleted.connect(_on_resource_node_depleted)
				resource_layer.set_cell(coords, resource_type, Vector2.ZERO)

	chunk_generated.emit(chunk)


func _on_camera_chunk_changed(chunk: Vector2i) -> void:
	_current_chunk = chunk


func _on_resource_node_depleted(resource_node: ResourceNode) -> void:
	var coordinates: Vector2i = _resource_nodes.find_key(resource_node)
	resource_layer.set_cell(coordinates)
	_resource_nodes.erase(coordinates)


func _determine_resource_type(coords: Vector2i) -> Resources.Type:
	var noise := cellular_noise_value_generator.get_noise_2d(coords.x, coords.y)
	if noise in noise_to_resource:
		return noise_to_resource[noise]

	var resource := Resources.get_random_ore()
	noise_to_resource[noise] = resource
	return resource

## deprecated
## clusters resources without using noise generator
func _determine_resource_type_without_noise(coords: Vector2i) -> Resources.Type:
	for i in range(-1, 2):
		for j in range(-1, 2):
			var adjacent_tile := coords + Vector2i(i, j)
			var tile_id := resource_layer.get_cell_source_id(adjacent_tile)
			if tile_id != -1:
				return tile_id as Resources.Type
	return Resources.get_random_ore()
