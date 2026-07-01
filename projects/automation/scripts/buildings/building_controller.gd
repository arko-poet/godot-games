extends Node

const _BuildingPreviewScene := preload("res://scenes/buildings/building_preview.tscn")
const _MineScene := preload("res://scenes/buildings/mine.tscn")

var _building_preview: BuildingPreview

@onready var _world: World = %World


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and _building_preview:
		get_viewport().set_input_as_handled()
		_place_building()


func _place_building() -> void:
	var mine: Mine = _MineScene.instantiate()
	mine.position = _building_preview.position
	mine.set_tiles(_world.layers.get_resource_nodes(mine.position, mine.TILE_RANGE))
	
	_world.add_child(mine)
	_building_preview.queue_free()


func _on_create_mine_pressed() -> void:
	_building_preview = _BuildingPreviewScene.instantiate()
	_building_preview.layer = _world.layers.resource_layer
	
	_world.add_child(_building_preview)
