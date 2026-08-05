class_name BuildingController
extends Node

const _BuildingPreviewScene := preload("res://scenes/buildings/building_preview.tscn")
const _MineScene := preload("res://scenes/buildings/mine.tscn")
const _FurnaceScene := preload("res://scenes/buildings/furnace.tscn")
const _AssemblerScene := preload("res://scenes/buildings/assembler.tscn")
const _InserterScene := preload("res://scenes/buildings/inserter.tscn")
const _BeltScene := preload("res://scenes/buildings/belt.tscn")

var _building_preview: BuildingPreview
var _building: Building

@onready var world: World = %World


func _input(event: InputEvent) -> void:
	if not _building_preview:
		return

	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if _can_place_building():
					_place_building()
			MOUSE_BUTTON_RIGHT:
				_building_preview.rotate(Building.RIGHT_ANGLE)
			_:
				return
		get_viewport().set_input_as_handled()


func _place_building() -> void:
	_building.position = _building_preview.position
	_building.show()
	_building.rotate(_building_preview.rotation)

	if _building.has_method(&"set_tiles"):
		_building.set_tiles(world.layers.get_resource_nodes(
				_building.position,
				_building.TILE_RANGE,
			))

	world.register_building(_building)

	_building_preview.queue_free()


func _create_building_preview() -> void:
	_building.hide()
	world.add_child(_building)

	_building_preview = _BuildingPreviewScene.instantiate()
	world.add_child(_building_preview)

	var sprite: Sprite2D = _building.find_child(^"Sprite")
	if sprite:
		_building_preview.sprite.texture = sprite.texture
	_building_preview.layer = world.layers.resource_layer


func _can_place_building() -> bool:
	var center_tile := world.get_tile(_building_preview.position)
	var building_radius := _building.footprint_size
	for i in range(center_tile.x - building_radius, center_tile.x + building_radius + 1):
		for j in range(center_tile.y - building_radius, center_tile.y + building_radius + 1):
			var tile := Vector2i(i, j)
			if not world.is_cell_free(tile):
				return false

	return true


func _on_create_mine_pressed() -> void:
	_create_building(_MineScene)


func _on_create_furnace_pressed() -> void:
	_create_building(_FurnaceScene)


func _on_create_assembler_pressed() -> void:
	_create_building(_AssemblerScene)


func _on_create_inserter_pressed() -> void:
	_create_building(_InserterScene)
	_building.world = world


func _on_create_belt_pressed() -> void:
	_create_building(_BeltScene)


func _create_building(building_scene: PackedScene) -> void:
	_building = building_scene.instantiate()
	_create_building_preview()
