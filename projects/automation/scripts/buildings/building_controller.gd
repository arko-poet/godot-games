extends Node

const _BuildingPreviewScene := preload("res://scenes/buildings/building_preview.tscn")
const _MineScene := preload("res://scenes/buildings/mine.tscn")
const _FurnanceScene := preload("res://scenes/buildings/furnance.tscn")
const _AssemblerScene := preload("res://scenes/buildings/assembler.tscn")

var _building_preview: BuildingPreview
var _building: Node2D

@onready var _world: World = %World


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and _building_preview:
		get_viewport().set_input_as_handled()
		_place_building()


func _place_building() -> void:
	_building.position = _building_preview.position
	
	if _building.has_method(&"set_tiles"):
		_building.set_tiles(_world.layers.get_resource_nodes(_building.position, _building.TILE_RANGE))
	
	_building.show()
	
	_building_preview.queue_free()


func _on_create_mine_pressed() -> void:
	_building = _MineScene.instantiate()
	_create_building_preview()


func _on_create_furnance_pressed() -> void:
	_building = _FurnanceScene.instantiate()
	_create_building_preview()


func _create_building_preview() -> void:
	_building.hide()
	_world.add_child(_building)
	
	_building_preview = _BuildingPreviewScene.instantiate()
	_world.add_child(_building_preview)
	
	_building_preview.sprite.texture = _building.sprite.texture
	_building_preview.layer = _world.layers.resource_layer


func _on_create_assembler_pressed() -> void:
	_building = _AssemblerScene.instantiate()
	_create_building_preview()
