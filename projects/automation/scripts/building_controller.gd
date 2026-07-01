class_name BuildingController extends Node

const BuildingPreview := preload("res://scenes/building_preview.tscn")
const MineScene := preload("res://scenes/mine.tscn")

var building_preview: Node2D

@onready var world: World = %World


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and building_preview:
		get_viewport().set_input_as_handled()
		var mine: Mine = MineScene.instantiate()
		mine.position = building_preview.position
		mine.tiles = world.layers.get_resource_tiles(mine.position, mine.TILE_RANGE)
		world.add_child(mine)
		building_preview.queue_free()
		

func _on_create_mine_pressed() -> void:
	building_preview = BuildingPreview.instantiate()
	building_preview.tile_map_layer = world.layers.resource_layer
	world.add_child(building_preview)
