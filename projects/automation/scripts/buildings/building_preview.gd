class_name BuildingPreview
extends Node2D

var layer: TileMapLayer

@onready var sprite: Sprite2D = %Sprite


func _process(_delta: float) -> void:
	if not layer:
		return

	var hovered_tile := layer.local_to_map(get_global_mouse_position())
	position = layer.map_to_local(hovered_tile)
