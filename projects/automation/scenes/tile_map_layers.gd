extends Node2D

signal resource_hovered(resource: TileResourceData)

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer

var noise_generator := preload("res://resources/noise_generator.tres")

var drawn_chunks: Dictionary[Vector2i, bool]

var resources: Dictionary[Vector2i, TileResourceData]

var hovered_coords: Vector2i

func _ready() -> void:
	#seed(1)
	#randomize()
	#noise.seed = 0
	_draw_chunks(Vector2.ZERO)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var coords := resource_layer.local_to_map(get_local_mouse_position())
		if coords not in resources:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			hovered_coords = Vector2i.MIN
			resource_hovered.emit(null)
		elif coords != hovered_coords:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			hovered_coords = coords
			resource_hovered.emit(resources[coords])
	elif event is InputEventMouseButton and event.is_pressed():
		pass


func _draw_chunks(center_chunk: Vector2i) -> void:
	for x in range(center_chunk.x - 1, center_chunk.x  + 2):
		for y in range(center_chunk.y - 1, center_chunk.y  + 2):
			var chunk := Vector2i(x, y)
			if chunk not in drawn_chunks:
				_draw_chunk(chunk)
				drawn_chunks[chunk] = true


func _draw_chunk(chunk: Vector2i) -> void:
	var chunk_size := World.CHUNK_SIZE
	for x in chunk_size:
		for y in chunk_size:
			var coords := Vector2i(x + chunk.x * chunk_size, y + chunk.y * chunk_size)
			terrain_layer.set_cell(coords, 0, Vector2.ZERO)
			var noise := noise_generator.get_noise_2d(coords.x, coords.y)
			if noise <= -0.75:
				resources[coords] = TileResourceData.new(TileResourceData.ResourceType.COAL)
				resource_layer.set_cell(coords, 0, Vector2.ZERO)


func _on_camera_chunk_changed(chunk: Vector2i) -> void:
	_draw_chunks(chunk)
