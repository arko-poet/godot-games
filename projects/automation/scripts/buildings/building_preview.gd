class_name BuildingPreview extends Node2D

var footprint: Array[Vector2i]
var center_tile: Vector2i

var layer: TileMapLayer

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	for i in 3:
		for j in 3:
			footprint.append(Vector2i(i, j))
	
	center_tile = Vector2i(1, 1)


func _process(_delta: float) -> void:
	if not layer:
		return
	
	var hovered_tile := layer.local_to_map(get_global_mouse_position())
	position = layer.map_to_local(hovered_tile)
