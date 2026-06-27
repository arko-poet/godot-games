extends Node2D

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer


func _ready() -> void:
	_draw_chunk(0, 0)
	_draw_chunk(-1, -1)


func _draw_chunk(x, y) -> void:
	var chunk_size := World.CHUNK_SIZE
	for i in chunk_size:
		for j in chunk_size:
			terrain_layer.set_cell(Vector2i(i + x * chunk_size, j + y * chunk_size), 0, Vector2.ZERO)
