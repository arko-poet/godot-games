class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

const BuildingPreview := preload("res://scenes/building_preview.tscn")
const MineScene := preload("res://scenes/mine.tscn")

var building_preview: Node2D

@onready var tile_map_layers: TileMapLayers = $TileMapLayers


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and building_preview:
		var mine: Mine = MineScene.instantiate()
		mine.position = building_preview.position
		mine.tiles = tile_map_layers.get_resource_tiles(mine.position, mine.TILE_RANGE)
		add_child(mine)
		

func _on_create_mine_pressed() -> void:
	building_preview = BuildingPreview.instantiate()
	building_preview.tile_map_layer = tile_map_layers.resource_layer
	add_child(building_preview)
