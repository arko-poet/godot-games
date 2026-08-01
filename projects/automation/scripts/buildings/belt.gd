class_name Belt
extends Node2D

var world: World

var stored_item: Item
var moving_item: Item
var item_displacement: Vector2

@onready var building_component: BuildingComponent = %BuildingComponent


func _on_production_timer_timeout() -> void:
	var direction := _get_direction()

	var destination := building_component.center_cell + direction
	var destination_node := world.get_node_at_cell(destination)
	var belt: Belt
	if destination_node is not Belt:
		return
	belt = destination_node

	if belt == null or belt.stored_item != null:
		return

	if moving_item == null:
		moving_item = stored_item
		stored_item = null
		
	if moving_item:
		if item_displacement.length() == World.TILE_SIZE:
			belt.stored_item = moving_item
			moving_item.cell = destination + direction
			moving_item = null
			item_displacement = Vector2.ZERO
		else:
			moving_item.position += Vector2(direction)
			item_displacement += Vector2(direction)

func _get_direction() -> Vector2i:
	var rotation_count := int(round(rotation / (TAU / 4.0))) % 4
	match rotation_count:
		0:
			return Vector2i.RIGHT
		1:
			return Vector2i.DOWN
		2:
			return Vector2i.LEFT
		3:
			return Vector2i.UP
		_:
			push_error("Invalid inserter direction")
			return Vector2i.RIGHT
