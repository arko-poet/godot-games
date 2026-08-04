class_name Belt
extends Building

var world: World

var stored_item: Item
var moving_item: Item
## how much moving_item has been displaced, used for determining when to pass it to next inserter
var _item_displacement: Vector2


func _on_displacement_timer_timeout() -> void:
	if not world:
		push_error("world reference has not been set")
		return

	var direction := _get_direction()
	var destination_node := world.get_node_at_cell(center_cell + direction)
	if destination_node is not Belt:
		return

	_displace_item(destination_node, direction)


func _displace_item(target_belt: Belt, direction: Vector2) -> void:
	if target_belt.stored_item != null:
		return

	if moving_item == null:
		moving_item = stored_item
		stored_item = null

	if not moving_item:
		return

	if _item_displacement.length() >= World.TILE_SIZE:
		target_belt.stored_item = moving_item
		moving_item = null
		_item_displacement = Vector2.ZERO
	else:
		moving_item.position += direction
		_item_displacement += direction
