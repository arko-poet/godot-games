extends Node2D

const CHUNK_SIZE := 32

@onready var terrain_layer: TileMapLayer = %TerrainLayer
@onready var resource_layer: TileMapLayer = %ResourceLayer


func _ready() -> void:
	_draw_chunk(0, 0)


func _draw_chunk(x, y) -> void:
	for i in CHUNK_SIZE:
		for j in CHUNK_SIZE:
			terrain_layer.set_cell(Vector2i(i + x * CHUNK_SIZE, j + y * CHUNK_SIZE), 0, Vector2.ZERO)
