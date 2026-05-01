@tool class_name Bag extends Control

signal rotated

@export_range(1, Inventory.INVENTORY_SIZE) var columns: int = 1
@export_range(1, Inventory.INVENTORY_SIZE) var rows: int = 1
@export var bg_color: Color = Color("#6B3F1E")
@export var border_color: Color = Color("#C4955A")

var footprint: Array[Vector2i]
## items which are partially contained in the bag
var partial_items: Array[Item]
## items which are fully contained in the bag with the top left cell they occupy
var full_items: Dictionary[Item, Vector2i]
var cell_held: Vector2i ## TODO perhaps not needed, could be part of preview data
var preview: Control
var preview_rotations := 0.0


func _ready() -> void:
	custom_minimum_size = Vector2(columns, rows) * Inventory.CELL_SIZE
	for row in rows:
		for column in columns:
			var cell := Vector2i(column, row)
			footprint.append(cell)
	queue_redraw()


func _draw() -> void:
	for row in rows:
		for column in columns:
			var cell := Vector2i(column, row)
			var cell_position := cell * Inventory.CELL_SIZE
			var cell_size := Vector2i(Inventory.CELL_SIZE, Inventory.CELL_SIZE)
			var rect2i := Rect2i(cell_position, cell_size)
			draw_rect(rect2i, bg_color)
			draw_rect(rect2i, border_color, false, 1)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not get_viewport().gui_is_drag_successful():
			unrotate()
		preview_rotations = 0.0
		
		show()
		for item in full_items:
			item.show()


func clear_items() -> void:
	partial_items.clear()
	full_items.clear()


func rotate() -> void:
	preview_rotations += PI / 2
	rotation += PI / 2
	preview.rotation += PI / 2
	cell_held = Vector2i(-cell_held.y, cell_held.x)
	for i in footprint.size():
		footprint[i] = Vector2i(-footprint[i].y, footprint[i].x)
		
	for item in full_items:
		item.rotate()
		full_items[item] = Vector2i(-full_items[item].y, full_items[item].x)
	
	rotated.emit()


func unrotate() -> void:
	while preview_rotations > 0.0:
		preview_rotations -= PI / 2
		rotation -= PI / 2
		#preview.rotation -= PI / 2
		#cell_held = Vector2i(cell_held.y, -cell_held.x) # (x, y) -> (-y, x) -> (y, -x)
		for i in footprint.size():
			footprint[i] = Vector2i(footprint[i].y, -footprint[i].x)
			
		for item in full_items:
			item.unrotate()
			full_items[item] = Vector2i(full_items[item].y, -full_items[item].x)


## return visual top left corner of the Item while respecting rotation
func get_top_left_corner() -> Vector2:
	var local_transform := Transform2D(rotation, Vector2.ZERO)
	var local_rect := Rect2(Vector2.ZERO, get_rect().size)
	return (local_transform * local_rect).position


func _on_gui_input(event: InputEvent) -> void:
	#print("Bag click, partial_items: ", partial_items.size(), " full_items: ", full_items.size())
	var mb := event as InputEventMouseButton
	if mb != null:
		if mb.button_index != MOUSE_BUTTON_LEFT:
			return
		
		if not partial_items.is_empty():
			return
		
		assert(mb.pressed)
		_start_dragging()


func _start_dragging() -> void:
	var mp := get_local_mouse_position()
	
	var preview_display: Bag = duplicate()
	preview_display.position = -mp
	preview_display.rotation = rotation

	preview = Control.new()
	preview.size = preview_display.size # TODO is this even needed?
	preview.add_child(preview_display)
	preview_display.pivot_offset = mp
	for item in full_items:
		
		var d_item: Item = item.duplicate()
		d_item.rotation = item.rotation
		
		# TODO explain how this works
		var item_relative_to_bag := get_transform().inverse() * item.get_transform()
		var final_item_transform := preview_display.get_transform() * item_relative_to_bag
		d_item.position = final_item_transform.origin

		preview.add_child(d_item)

	var drag_data := {
		"bag": self,
		"offset": mp * Transform2D(-rotation, Vector2.ZERO),
		"items": full_items.keys()
	}
	
	_set_cell_held()

	force_drag.call_deferred(drag_data, preview)
	hide()
	for item in full_items:
		item.hide()


func _set_cell_held() -> void:
	var mp := get_local_mouse_position() / Inventory.CELL_SIZE
	cell_held = Vector2i(mp * Transform2D(-rotation, Vector2.ZERO))


func _on_mouse_entered() -> void:
	self_modulate = Color(1.1, 1.1, 1.1)


func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0)
