class_name TileMapLayers extends Node2D

signal resource_hovered(resource: ResourceNode)
signal resource_collected(type: Resources.Type, quantity: int)

const _NOISE_THRESHOLD := -0.75

const _NoiseGenerator := preload("res://resources/noise_generator.tres")

var _drawn_chunks: Array[Vector2i]
var _resource_nodes: Dictionary[Vector2i, ResourceNode]
var _hovered_coords: Vector2i

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer

func _ready() -> void:
	#seed(1)
	#randomize()
	#noise.seed = 0
	_generate_chunks(Vector2.ZERO)


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
	elif event is InputEventMouseButton and event.is_pressed() and _hovered_coords != Vector2i.MIN:
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


func _generate_chunks(center_chunk: Vector2i) -> void:
	for x in range(center_chunk.x - 1, center_chunk.x + 2):
		for y in range(center_chunk.y - 1, center_chunk.y  + 2):
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
			
			var noise := _NoiseGenerator.get_noise_2d(coords.x, coords.y)
			if noise <= _NOISE_THRESHOLD:
				var resource_type = Resources.Type.values()[randi() % Resources.Type.size()]
				var resource_node := ResourceNode.new(resource_type)
				_resource_nodes[coords] = resource_node
				resource_node.depleted.connect(_on_resource_node_depleted)
				resource_layer.set_cell(coords, resource_type, Vector2.ZERO)


func _on_camera_chunk_changed(chunk: Vector2i) -> void:
	_generate_chunks(chunk)


func _on_resource_node_depleted(resource_node: ResourceNode) -> void:
	var coordinates: Vector2i = _resource_nodes.find_key(resource_node)
	resource_layer.set_cell(coordinates)
	_resource_nodes.erase(coordinates)
