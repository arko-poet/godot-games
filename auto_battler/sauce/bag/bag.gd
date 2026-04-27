@tool class_name Bag extends Control

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
		show()


func _on_gui_input(event: InputEvent) -> void:
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

	var preview := Control.new()
	preview.size = preview_display.size
	preview.add_child(preview_display)
	for item in full_items:
		var d_item: Item = item.duplicate()
		d_item.position = - Vector2(full_items[item]) * Inventory.CELL_SIZE - mp
		preview.add_child(d_item)

	
	var drag_data := {
		"bag": self,
		"offset": mp,
		"items": full_items.keys()
	}
	force_drag.call_deferred(drag_data, preview)
	hide()
	_set_cell_held()


func _set_cell_held() -> void:
	var mp := get_local_mouse_position() / Inventory.CELL_SIZE
	cell_held = Vector2i(mp * Transform2D(-rotation, Vector2.ZERO))
