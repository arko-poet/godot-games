## anything that can be placed on the [Inventory]
@abstract class_name InventoryComponent extends Control

signal rotated

const HOVER_HIGHLIGHT_MODULATE := Color(1.1, 1.1, 1.1)

## representation of component's shape, which grid cells it is going to occupy
var footprint: Array[Vector2i]
## counts number of times component has been rotated while dragging
var rotation_counter = 0
var physical_item


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not get_viewport().gui_is_drag_successful():
			_unrotate()
		rotation_counter = 0
		
		#_show_component()
#
#
#func _show_component() -> void:
	#show()


## return visual top left corner of the while respecting rotation
func get_top_left_corner() -> Vector2:
	var local_transform := Transform2D(rotation, Vector2.ZERO)
	var local_rect := Rect2(Vector2.ZERO, get_rect().size)
	return (local_transform * local_rect).position


## when extending make sure to call super() at the end so rotated fires ar right time
func rotate() -> void:
	rotation_counter += 1
	
	rotation += PI / 2
	for i in footprint.size():
		footprint[i] = Vector2i(-footprint[i].y, footprint[i].x)
	
	rotated.emit()


func _unrotate() -> void:
	while rotation_counter > 0:
		rotation_counter -= 1
		
		rotation -= PI / 2
		for i in footprint.size():
			footprint[i] = Vector2i(footprint[i].y, -footprint[i].x)
			
			
func _on_gui_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null:
		print("in inventory_component")
		if _should_not_start_dragging(mb):
			return
		assert(mb.pressed)

		_start_dragging()
		
		
func _should_not_start_dragging(event: InputEventMouseButton) -> bool:
	return event.button_index != MOUSE_BUTTON_LEFT
	

func test_drag(p_position: Vector2) -> void:
	global_position = p_position
	_start_dragging()


func _start_dragging() -> void:
	var lmp := get_local_mouse_position()
	var preview: Control = _create_drag_preview(lmp)
	var data: Dictionary = _create_drag_data(preview, lmp)
	
	force_drag.call_deferred(data, preview)
	
	hide()


@abstract func _create_drag_preview(preview_position: Vector2) -> Control


@abstract func _create_drag_data(drag_preview: Control, preview_position: Vector2) -> Dictionary
	
	
## TODO write comment on what this actually intends to return
func _get_cell_held(held_position: Vector2) -> Vector2i:
	var lmp := held_position / Inventory.CELL_SIZE
	return Vector2i(lmp * Transform2D(-rotation, Vector2.ZERO))


func _on_mouse_entered() -> void:
	self_modulate = HOVER_HIGHLIGHT_MODULATE


func _on_mouse_exited() -> void:
	self_modulate = Color.WHITE
