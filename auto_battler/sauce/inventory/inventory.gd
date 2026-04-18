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
const BONUS_BG_COLOR := Color.GOLD

## Item if cell occupied, null otherwise
var item_grid: Array[Array] = [] 
## a cell cursor is hovering over
var last_hovered_cell: Vector2i
## currently hovered cells, used for redrawing grid
var hovered_cells: Array[Vector2i] = []
## hover only
var bonus_cells: Array[Vector2i] = []
var items: Array[Item] = []
## changes depending on if drop is allowed or not
var hover_color: Color 
## hovered cells need changing if true
var update_rotation: bool = false 
## Array[Array[Array[Item]]] - each grid cell has list of Items which contribute bonus to that cell
var bonuses: Array[Array] = [] 

func _ready() -> void:
	custom_minimum_size = Globals.CELL_SIZE * Vector2i(INVENTORY_SIZE, INVENTORY_SIZE)
	
	for y in INVENTORY_SIZE:
		var row: Array[Item] = []
		for x in INVENTORY_SIZE:
			row.append(null)
		item_grid.append(row)
	
	for y in INVENTORY_SIZE:
		var row: Array[Array] = []
		for x in INVENTORY_SIZE:
			row.append([])
		bonuses.append(row)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		hovered_cells.clear()
		bonus_cells.clear()
		queue_redraw()
		

func _draw():
	# inventory grid
	for y in INVENTORY_SIZE:
		for x in INVENTORY_SIZE:
			var cell := Vector2i(x, y)
			var cell_position := cell * Globals.CELL_SIZE
			var cell_size := Vector2i(Globals.CELL_SIZE, Globals.CELL_SIZE)
			var rect2i := Rect2i(cell_position, cell_size)
			var bg_color: Color = BG_COLOR
			if cell in hovered_cells:
				bg_color = hover_color
			elif cell in bonus_cells:
				bg_color = BONUS_BG_COLOR
			draw_rect(rect2i, bg_color)
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
		bonus_cells.clear()
		for item_cell in item.get_footprint():
			hovered_cells.append(hovered_cell + item_cell - item.cell_held)
		last_hovered_cell = hovered_cell
		for item_cell in item.bonus_cells:
			var bonus_cell: Vector2i = hovered_cell + item_cell - item.cell_held
			if (
				bonus_cell.x >= 0 and bonus_cell.y >= 0 
				and bonus_cell.x < INVENTORY_SIZE and bonus_cell.y < INVENTORY_SIZE
			):
				bonus_cells.append(hovered_cell + item_cell - item.cell_held)
	
	var can_drop: bool = true
	for hc in hovered_cells:
		if (
			hc.y < 0 or hc.x < 0
			or hc.y >= INVENTORY_SIZE or hc.x >= INVENTORY_SIZE
		):
			can_drop = false
			break
	
	if redraw_needed:
		hover_color = CAN_DROP_BG_COLOR if can_drop else CANT_DROP_BG_COLOR
		queue_redraw()
	
	return can_drop


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item: Item = data["item"]
	_clear_hovered(item)
	if items.has(item):
		_move_item(item)
	else:
		_add_item(item)
	hovered_cells.clear()
	bonus_cells.clear()
	
	queue_redraw()


func rotate_hovered_cells() -> void:
	update_rotation = true
	_can_drop_data(get_local_mouse_position(), get_viewport().gui_get_drag_data())


func remove_item(item: Item) -> void:
	for row_i in INVENTORY_SIZE:
		for col_i in INVENTORY_SIZE:
			_remove_bonuses(item)
			if item == item_grid[row_i][col_i]:
				items.erase(item)
				item_grid[row_i][col_i] = null
	item_removed.emit(item)


## remove items present in hovered cells except the specified one (typically one dragging)
func _clear_hovered(except_item: Item) -> void:
	var overlapping_items: Array[Item] = []
	for hc in hovered_cells:
		var item: Item = item_grid[hc.y][hc.x]
		if item != null and item not in overlapping_items:
			overlapping_items.append(item)
	
	for item in overlapping_items:
		if item != except_item:
			remove_item(item)


func _on_mouse_exited() -> void:
	if get_viewport().gui_is_dragging():
		hovered_cells.clear()
		bonus_cells.clear()
		queue_redraw()


func _on_item_used(action: CombatAction) -> void:
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
	
	_apply_bonuses(item)


func _move_item(item: Item) -> void:
	print("move")
	_remove_bonuses(item)
	# clear previous item references
	for row in item_grid:
		for col_i in INVENTORY_SIZE:
			if item == row[col_i]:
				row[col_i] = null
	
	
	_place_item(item)


func _remove_bonuses(item: Item) -> void:
	print("removing")
	for ai in _get_affecting_items(_get_occupied_cells(item)):
		item.remove_bonus(ai)
	
	# find cell where the item applies bonus
	var array_name: Array[Vector2i] = [] # TODO find better name
	for row_i in INVENTORY_SIZE:
		for col_i in INVENTORY_SIZE:
			if bonuses[row_i][col_i].has(item) and not array_name.has(Vector2i(col_i, row_i)):
				array_name.append(Vector2i(col_i, row_i))
	print(array_name)
	
	# find items which have the item's bonus applied
	var bonus_items = []
	for xd in array_name:
		var item_in_grid: Item = item_grid[xd.y][xd.x]
		if item_in_grid != null and item_in_grid != item and not bonus_items.has(item_in_grid):
			bonus_items.append(item_in_grid)
	
	# remove the item's bonus from other items
	for bi in bonus_items:
		bi.remove_bonus(item)
	
	# clear bonuses:
	for row_i in INVENTORY_SIZE:
		for col_i in INVENTORY_SIZE:
			bonuses[row_i][col_i].erase(item)


func _apply_bonuses(item: Item) -> void:
	for ai in _get_affecting_items(_get_occupied_cells(item)):
		item.apply_bonus(ai)
	
	var array_name2: Array[Item] = []
	for bc in bonus_cells:
		assert(item not in bonuses[bc.y][bc.x])
		bonuses[bc.y][bc.x].append(item)
		var item_name: Item = item_grid[bc.y][bc.x]
		if item_name != null and not array_name2.has(item_name):
			array_name2.append(item_name)
	
	for i in array_name2:
		i.apply_bonus(item)


func _get_occupied_cells(item: Item) -> Array[Vector2i]:
	var occupied_cells: Array[Vector2i] = []
	for row_i in INVENTORY_SIZE:
		for col_i in INVENTORY_SIZE:
			if item_grid[row_i][col_i] == item:
				occupied_cells.append(Vector2i(col_i, row_i))
	return occupied_cells


## get all items that are providing bonus to the given cells
func _get_affecting_items(cells: Array[Vector2i]) -> Array[Item]:
	var affecting_items: Array[Item] = []
	for cell in cells:
		for bonus in bonuses[cell.y][cell.x]:
			if not affecting_items.has(bonus):
				affecting_items.append(bonus)
	return affecting_items
