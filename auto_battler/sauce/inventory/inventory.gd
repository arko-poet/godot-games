@tool
extends Control

signal item_used(effect: Dictionary)

const INVENTORY_SIZE := 8 ## height and width in number of cells
const CELL_SIZE := Vector2i(16, 16)
const BORDER_COLOR := Color("#5A6270")
const BG_COLOR := Color("#252A33")
const HOVER_COLOR := Color(0.0, 0.608, 0.0, 1.0)

var item_grid: Array[Array] = [] ## Item if cell occupied, null otherwise
var hovered_cells: Array[Vector2i] = [] ## currently hovered cells, used for redrawing grid
var items: Array[Item] = []

func _ready() -> void:
	custom_minimum_size = Vector2i(CELL_SIZE * INVENTORY_SIZE)
	
	for y in range(INVENTORY_SIZE):
		var row: Array[Item] = []
		for x in range(INVENTORY_SIZE):
			row.append(null)
		item_grid.append(row)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		hovered_cells.clear()
		queue_redraw()
		

func _draw():
	# inventory grid
	for y in range(INVENTORY_SIZE):
		for x in range(INVENTORY_SIZE):
			var cell := Vector2i(x, y)
			var rect2i := Rect2i(cell * CELL_SIZE, CELL_SIZE)
			draw_rect(rect2i, HOVER_COLOR if cell in hovered_cells else BG_COLOR)
			draw_rect(rect2i, BORDER_COLOR, false, 1)


func _can_drop_data(at_position: Vector2, _data: Variant) -> bool:
	var hovered_cell := _position_to_cell(at_position)
	if hovered_cell not in hovered_cells:
		hovered_cells.clear()
		hovered_cells.append(hovered_cell)
		queue_redraw()
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	_remove_item(item)
	_add_item(item, _position_to_cell(at_position))
	hovered_cells.clear()
	queue_redraw()


func _on_mouse_exited() -> void:
	if get_viewport().gui_is_dragging():
		hovered_cells.clear()
		queue_redraw()


func _on_item_used(effect: Dictionary) -> void:
	# TODO process item effect based on other items in the grid
	item_used.emit(effect)


func _on_combat_started() -> void:
	for item in items:
		item.effect_timer.start()


func _on_combat_finished() -> void:
	for item in items:
		item.effect_timer.stop()


## helper function because godot shows warning when performing integer division
func _position_to_cell(at_position: Vector2) -> Vector2i:
	var cell := Vector2i(
		floori(at_position.x / CELL_SIZE.x),
		floori(at_position.y / CELL_SIZE.y)
	)
	return cell


func _add_item(item: Item, grid_index: Vector2i) -> void:
	item_grid[grid_index.y][grid_index.x] = item
	item.position = Vector2i(position) + CELL_SIZE * grid_index
	items.append(item)


func _remove_item(item: Item) -> void:
	for row in item_grid:
		for col_i in range(len(row)):
			if item == row[col_i]:
				items.erase(row[col_i])
				row[col_i] = null
