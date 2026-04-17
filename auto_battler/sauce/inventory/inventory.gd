@tool
class_name Inventory
extends Control

signal item_used(action: CombatAction)
signal item_added(item: Item)
signal item_removed(item: Item)

const INVENTORY_SIZE := 6 ## height and width in number of cells
const BORDER_COLOR := Color("#5A6270")
const BG_COLOR := Color("#252A33")
const CAN_DROP_BG_COLOR := Color(0.0, 0.608, 0.0, 1.0)
const CANT_DROP_BG_COLOR := Color(0.69, 0.0, 0.0, 1.0)

var item_grid: Array[Array] = [] ## Item if cell occupied, null otherwise
var last_hovered_cell: Vector2i ## a cell cursor is hovering over
var hovered_cells: Array[Vector2i] = [] ## currently hovered cells, used for redrawing grid
var items: Array[Item] = []
var hover_color: Color ## changes depending on if drop is allowed or not
var update_rotation: bool = false ## hovered cells need changing if true


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


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var item: Item = data["item"]
	
	# check if cursor moved to other cell in which case hovered cells changed -> redraw needed
	var redraw_needed: bool = false
	var hovered_cell := _position_to_cell(at_position)
	if hovered_cell != last_hovered_cell or hovered_cells.is_empty() or update_rotation:
		update_rotation = false
		redraw_needed = true
		hovered_cells.clear()
		for item_cell in item.get_footprint():
			hovered_cells.append(hovered_cell + item_cell - item.cell_held)
		last_hovered_cell = hovered_cell
	
	var can_drop: bool = true
	for hc in hovered_cells:
		if (
			hc.y < 0 or hc.x < 0
			or hc.y >= INVENTORY_SIZE or hc.x >= INVENTORY_SIZE
			or not (item_grid[hc.y][hc.x] == null or item_grid[hc.y][hc.x] == item)
		):
			can_drop = false
			break
	
	if redraw_needed:
		hover_color = CAN_DROP_BG_COLOR if can_drop else CANT_DROP_BG_COLOR
		queue_redraw()
	
	return can_drop


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	if item in items:
		_move_item(item)
	else:
		_add_item(item)
	hovered_cells.clear()
	queue_redraw()


func rotate_hovered_cells() -> void:
	update_rotation = true
	_can_drop_data(get_local_mouse_position(), get_viewport().gui_get_drag_data())


func remove_item(item: Item) -> void:
	for row in item_grid:
		for col_i in range(len(row)):
			if item == row[col_i]:
				items.erase(row[col_i])
				row[col_i] = null
	item_removed.emit(item)


func _on_mouse_exited() -> void:
	if get_viewport().gui_is_dragging():
		hovered_cells.clear()
		queue_redraw()


func _on_item_used(action: CombatAction) -> void:
	# TODO process item effect based on other items in the grid
	item_used.emit(action)


func _on_combat_started(_combat_number: int) -> void:
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


func _add_item(item: Item) -> void:
	item.reparent(self)
	_place_item(item)
	items.append(item)
	item_added.emit(item)


func _place_item(item: Item) -> void:
	# without this check item would be palced outside of grid
	if hovered_cells.is_empty():
		return
		
	var column: int = INVENTORY_SIZE
	var row: int = INVENTORY_SIZE
	for cell in hovered_cells:
		column = min(column, cell.x)
		row = min(row, cell.y)
		item_grid[cell.y][cell.x] = item
		
	item.position = Vector2i(column, row) * Globals.CELL_SIZE - item.get_rotation_offset()


func _move_item(item: Item) -> void:
	for row in item_grid:
		for col_i in range(len(row)):
			if item == row[col_i]:
				row[col_i] = null
	_place_item(item)
