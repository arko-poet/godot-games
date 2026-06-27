extends Node2D

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer

var drawn_chunks: Dictionary[Vector2i, bool]


func _ready() -> void:
	_draw_chunks(Vector2.ZERO)


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


func _on_camera_chunk_changed(chunk: Vector2i) -> void:
	_draw_chunks(chunk)
