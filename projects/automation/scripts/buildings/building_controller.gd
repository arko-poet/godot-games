class_name BuildingController extends Node

const _BuildingPreviewScene := preload("res://scenes/buildings/building_preview.tscn")
const _MineScene := preload("res://scenes/buildings/mine.tscn")
const _FurnanceScene := preload("res://scenes/buildings/furnance.tscn")
const _AssemblerScene := preload("res://scenes/buildings/assembler.tscn")
const _InserterScene := preload("res://scenes/buildings/inserter.tscn")

var _building_preview: BuildingPreview
var _building: Node2D

@onready var world: World = %World


func _input(event: InputEvent) -> void:
	if _building_preview:
		get_viewport().set_input_as_handled()
	else:
		return
		
	if event is InputEventMouseButton and event.is_pressed():
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and _can_place_building():
			_place_building()
		else:
			_rotate_preview()


func _place_building() -> void:
	_building.position = _building_preview.position
	if _building is Mine or _building is Inserter:
		_building.activate()
	_building.show()
	_building.rotate(_building_preview.rotation)
	
	if _building.has_method(&"set_tiles"):
		_building.set_tiles(world.layers.get_resource_nodes(_building.position, _building.TILE_RANGE))
	
	world.register_building(_building)
	
	_building_preview.queue_free()


func _on_create_mine_pressed() -> void:
	_building = _MineScene.instantiate()
	_create_building_preview()


func _on_create_furnance_pressed() -> void:
	_building = _FurnanceScene.instantiate()
	_create_building_preview()


func _create_building_preview() -> void:
	_building.hide()
	world.add_child(_building)
	
	_building_preview = _BuildingPreviewScene.instantiate()
	world.add_child(_building_preview)
	
	var sprite: Sprite2D = _building.find_child(^"Sprite")
	if sprite:
		_building_preview.sprite.texture = sprite.texture
	_building_preview.layer = world.layers.resource_layer


func _on_create_assembler_pressed() -> void:
	_building = _AssemblerScene.instantiate()
	_create_building_preview()


func _on_create_inserter_pressed() -> void:
	_building = _InserterScene.instantiate()
	_building.world = world
	_create_building_preview()


func _can_place_building() -> bool:
	var center_tile := world.get_tile(_building_preview.position)
	var _building_radius := (_building.get_node(^"BuildingComponent") as BuildingComponent).footprint_size
	for i in range(center_tile.x - _building_radius, center_tile.x + _building_radius + 1):
		for j in range(center_tile.y - _building_radius, center_tile.y + _building_radius + 1):
			var tile := Vector2i(i, j)
			if not world.is_cell_free(tile):
				return false
	
	return true


func _rotate_preview() -> void:
	_building_preview.rotate(TAU / 4.0)
