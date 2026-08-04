class_name Belt
extends Building

var next_belt: Belt

var stored_item: Item
var moving_item: Item
## how much moving_item has been displaced, used for determining when to pass it to next inserter
var _item_displacement: Vector2


func _on_displacement_timer_timeout() -> void:
	if not next_belt or next_belt.stored_item != null:
		return

	if moving_item == null:
		moving_item = stored_item
		stored_item = null

	if not moving_item:
		return

	if _item_displacement.length() >= World.TILE_SIZE:
		next_belt.stored_item = moving_item
		moving_item = null
		_item_displacement = Vector2.ZERO
	else:
		var direction := Vector2(get_direction())
		moving_item.position += direction
		_item_displacement += direction
