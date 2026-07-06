class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

var _item_and_building_coords: Dictionary[Vector2i, Node2D]

@onready var layers: TileMapLayers = %Layers


func _on_child_entered_tree(node: Node) -> void:
	print(node)
