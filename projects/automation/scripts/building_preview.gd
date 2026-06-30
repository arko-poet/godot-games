extends Node2D

var footprint: Array[Vector2i]
var center_tile: Vector2i

var tile_map_layer: TileMapLayer


func _ready() -> void:
	for i in 3:
		for j in 3:
			footprint.append(Vector2i(i, j))
	
	center_tile = Vector2i(1, 1)


func _process(_delta: float) -> void:
	if not tile_map_layer:
		return
	
	var mouse_tile := tile_map_layer.local_to_map(get_global_mouse_position())
	position = tile_map_layer.map_to_local(mouse_tile)
	
