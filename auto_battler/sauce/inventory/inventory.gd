@tool
extends Control

signal item_used(effect: Dictionary)
signal item_added(item: Item)
signal item_removed(item: Item)

const INVENTORY_SIZE := 8 ## height and width in number of cells
const BORDER_COLOR := Color("#5A6270")
const BG_COLOR := Color("#252A33")
const CAN_DROP_BG_COLOR := Color(0.0, 0.608, 0.0, 1.0)
const CANT_DROP_BG_COLOR := Color(0.69, 0.0, 0.0, 1.0)

var item_grid: Array[Array] = [] ## Item if cell occupied, null otherwise
var hovered_cells: Array[Vector2i] = [] ## currently hovered cells, used for redrawing grid
var items: Array[Item] = []
var hover_color: Color ## changes depending on if drop is allowed or not

func _ready() -> void:
	custom_minimum_size = Globals.CELL_SIZE * Vector2i(INVENTORY_SIZE, INVENTORY_SIZE)
	
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
			var cell_position := cell * Globals.CELL_SIZE
			var cell_size := Vector2i(Globals.CELL_SIZE, Globals.CELL_SIZE)
			var rect2i := Rect2i(cell_position, cell_size)
			draw_rect(rect2i, hover_color if cell in hovered_cells else BG_COLOR)
			draw_rect(rect2i, BORDER_COLOR, false, 1)


func _can_drop_data(at_position: Vector2, _data: Variant) -> bool:
	var hovered_cell := _position_to_cell(at_position)
	var can_hover = item_grid[hovered_cell.y][hovered_cell.x] == null
	hover_color = CAN_DROP_BG_COLOR if can_hover else CANT_DROP_BG_COLOR
	if hovered_cell not in hovered_cells:
		hovered_cells.clear()
		hovered_cells.append(hovered_cell)
		queue_redraw()
	return can_hover


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	var cell := _position_to_cell(at_position)
	if item in items:
		_move_item(item, cell)
	else:
		_add_item(item, cell)
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
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.used.connect(_on_item_used)
		item.effect_timer.start()


func _on_combat_finished() -> void:
	for item in items:
		item.mouse_filter = Control.MOUSE_FILTER_STOP
		item.used.disconnect(_on_item_used)
		item.effect_timer.stop()


## helper function because godot shows warning when performing integer division
func _position_to_cell(at_position: Vector2) -> Vector2i:
	var cell := Vector2i(
		floori(at_position.x / Globals.CELL_SIZE),
		floori(at_position.y / Globals.CELL_SIZE)
	)
	return cell


func _add_item(item: Item, cell: Vector2i) -> void:
	_place_item(item, cell)
	items.append(item)
	item_added.emit(item)


func _place_item(item: Item, cell: Vector2i) -> void:
	item_grid[cell.y][cell.x] = item
	item.position = Vector2i(position) + Globals.CELL_SIZE * cell


func _remove_item(item: Item) -> void:
	for row in item_grid:
		for col_i in range(len(row)):
			if item == row[col_i]:
				items.erase(row[col_i])
				row[col_i] = null
	item_removed.emit(item)


func _move_item(item: Item, cell: Vector2i) -> void:
	for row in item_grid:
		for col_i in range(len(row)):
			if item == row[col_i]:
				row[col_i] = null
	_place_item(item, cell)
