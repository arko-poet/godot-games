@tool
class_name Inventory extends Control

signal item_used(action: CombatAction)
signal item_added(item: Item)
signal item_removed(item: Item)

const CELL_SIZE := 16
const INVENTORY_SIZE := 6 ## height and width in number of cells
const BORDER_COLOR := Color(0.35, 0.38, 0.44, 0.25)
const BG_COLOR := Color(0.15, 0.17, 0.2, 0.25)
const CAN_DROP_BG_COLOR := Color(0.0, 0.608, 0.0, 0.5)
const CANT_DROP_BG_COLOR := Color(0.69, 0.0, 0.0, 0.5)
const BONUS_BG_COLOR := Color.GOLD

## Array[Array[Item]] Item if cell occupied, null otherwise
var item_grid: Array[Array] = [] 
## a cell cursor is hovering over
var last_hovered_cell: Vector2i
## cells item is hovering over
var hovered_cells: Array[Vector2i] = []
## bonus cells of item that is hovering
var hovered_bonus_cells: Array[Vector2i] = []
var items: Array[Item] = []
## changes depending on if drop is allowed or not
var hover_color: Color 
## informs inventory that it should redraw because item was rotated
var update_rotation: bool = false 
## Array[Array[Array[Item]]] - each grid cell has list of Items which contribute bonus to that cell
var bonus_providers: Array[Array] = [] 
var bags: Array[Bag] = []
var bag_grid: Array[Array] = []

func _ready() -> void:
	custom_minimum_size = CELL_SIZE * Vector2i(INVENTORY_SIZE, INVENTORY_SIZE)
	
	for y in INVENTORY_SIZE:
		var grid_row: Array[Item] = []
		var bag_grid_row: Array[Bag] = []
		var bonus_row: Array[Array] = []
		for x in INVENTORY_SIZE:
			grid_row.append(null)
			bonus_row.append([])
			bag_grid_row.append(null)
		item_grid.append(grid_row)
		bonus_providers.append(bonus_row)
		bag_grid.append(bag_grid_row)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		hovered_cells.clear()
		hovered_bonus_cells.clear()
		queue_redraw()
		

func _draw() -> void:
	# inventory grid
	for y in INVENTORY_SIZE:
		for x in INVENTORY_SIZE:
			var cell := Vector2i(x, y)
			var cell_position := cell * CELL_SIZE
			var cell_size := Vector2i(CELL_SIZE, CELL_SIZE)
			var rect2i := Rect2i(cell_position, cell_size)
			var bg_color: Color = BG_COLOR
			if cell in hovered_cells:
				bg_color = hover_color
			elif cell in hovered_bonus_cells:
				bg_color = BONUS_BG_COLOR
			draw_rect(rect2i, bg_color)
			draw_rect(rect2i, BORDER_COLOR, false, 1)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data.has("item"): # TODO make it better
		return _can_drop_item(at_position, data)
	else:
		return _can_drop_bag(at_position, data)	


func _can_drop_item(at_position: Vector2, data: Dictionary) -> bool:
	var item: Item = data["item"]
	# check if cursor moved to other cell in which case hovered cells changed -> redraw needed
	var redraw_needed: bool = false
	var hovered_cell := _position_to_cell(at_position)
	if hovered_cell != last_hovered_cell or hovered_cells.is_empty() or update_rotation:
		update_rotation = false
		redraw_needed = true
		hovered_cells.clear()
		hovered_bonus_cells.clear()
		for item_cell in item.footprint:
			hovered_cells.append(hovered_cell + item_cell - item.cell_held)
		last_hovered_cell = hovered_cell
		for item_cell in item.bonus_cells:
			var bonus_cell: Vector2i = hovered_cell + item_cell - item.cell_held
			if (
				bonus_cell.x >= 0 and bonus_cell.y >= 0 
				and bonus_cell.x < INVENTORY_SIZE and bonus_cell.y < INVENTORY_SIZE
			):
				hovered_bonus_cells.append(bonus_cell)
	
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


func _can_drop_bag(at_position: Vector2, data: Dictionary) -> bool:
	var bag: Bag = data["bag"]
	## check if cursor moved to other cell in which case hovered cells changed -> redraw needed
	var redraw_needed: bool = false
	var hovered_cell := _position_to_cell(at_position)
	if hovered_cell != last_hovered_cell or hovered_cells.is_empty() or update_rotation:
		update_rotation = false
		redraw_needed = true
		hovered_cells.clear()
		hovered_bonus_cells.clear()
		for bag_cell in bag.footprint:
			hovered_cells.append(hovered_cell + bag_cell - bag.cell_held)
		last_hovered_cell = hovered_cell
	
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
	var drop_object: Control
	if data.has("item"):
		drop_object = data["item"]
		_clear_hovered(drop_object)
		if items.has(drop_object): _move_item(drop_object)
		else: _add_item(drop_object)

	else:
		drop_object = data["bag"]
		if bags.has(drop_object): _move_bag(drop_object)
		else: _add_bag(drop_object)

	hovered_cells.clear()
	hovered_bonus_cells.clear()
	
	queue_redraw()


func remove_item(item: Item) -> void:
	_remove_bonuses(item)
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			if item == item_grid[row][col]:
				items.erase(item)
				item_grid[row][col] = null
	item_removed.emit(item)


func rotate_hovered_cells() -> void:
	update_rotation = true
	_can_drop_data(get_local_mouse_position(), get_viewport().gui_get_drag_data())


func _on_mouse_exited() -> void:
	if get_viewport().gui_is_dragging():
		hovered_cells.clear()
		hovered_bonus_cells.clear()
		queue_redraw()


#region Item Placement
func _add_item(item: Item) -> void:
	item.reparent(self)
	_place_item(item)
	items.append(item)
	item_added.emit(item)


func _place_item(item: Item) -> void:
	# without this check item would be palced outside of grid
	if hovered_cells.is_empty():
		return
		
	# find top left corner of item
	var column: int = INVENTORY_SIZE
	var row: int = INVENTORY_SIZE
	for cell in hovered_cells:
		column = min(column, cell.x)
		row = min(row, cell.y)
		item_grid[cell.y][cell.x] = item
	
	item.position = Vector2(column, row) * CELL_SIZE - item.get_top_left_corner()
	
	for bc in hovered_bonus_cells:
		assert(item not in bonus_providers[bc.y][bc.x])
		@warning_ignore("unsafe_cast") # bonus_providers cant be typed properly
		(bonus_providers[bc.y][bc.x] as Array).append(item)
	
	_apply_bonuses(item)


func _move_item(item: Item) -> void:
	# clear previous item references
	_remove_bonuses(item)
	for row in item_grid:
		for col_i in INVENTORY_SIZE:
			if item == row[col_i]:
				row[col_i] = null
	_place_item(item)

#region Bag Placement
func _place_bag(bag: Bag) -> void:
	# without this check item would be palced outside of grid
	if hovered_cells.is_empty():
		return
		
	# find top left corner of item
	var column: int = INVENTORY_SIZE
	var row: int = INVENTORY_SIZE
	for cell in hovered_cells:
		column = min(column, cell.x)
		row = min(row, cell.y)
		bag_grid[cell.y][cell.x] = bag
	
	bag.position = Vector2(column, row) * CELL_SIZE# - bag.get_top_left_corner()


func _move_bag(bag: Bag) -> void:
	# clear previous bag references
	for row in bag_grid:
		for col_i in INVENTORY_SIZE:
			if bag == row[col_i]:
				row[col_i] = null
	_place_bag(bag)
	
	
func _add_bag(bag: Bag) -> void:
	bag.reparent(self)
	_place_bag(bag)
	bags.append(bag)
	#item_added.emit(item)
#endregion


## remove items present in hovered cells except the specified one (typically one dragging)
func _clear_hovered(except_item: Item) -> void:
	var overlapping_items: Array[Item] = []
	for hc in hovered_cells:
		var item: Item = item_grid[hc.y][hc.x]
		if item != null and item not in overlapping_items:
			overlapping_items.append(item)
	
	overlapping_items.erase(except_item)
	for item in overlapping_items:
		remove_item(item)
#endregion


#region Bonuses
func _remove_bonuses(item: Item) -> void:
	for i in _get_affecting_items(_get_occupied_cells(item)):
		item.remove_bonus(i)
	
	for i in _get_affected_items(_get_affected_cells(item)):
		i.remove_bonus(item)
	
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			@warning_ignore("unsafe_cast") # bonus_providers cant be typed properly
			(bonus_providers[row][col] as Array).erase(item)


func _apply_bonuses(item: Item) -> void:	
	for i in _get_affecting_items(_get_occupied_cells(item)):
		item.apply_bonus(i)
	
	for i in _get_affected_items(_get_affected_cells(item)):
		i.apply_bonus(item)
#endregion


#region Helpers
func _get_occupied_cells(item: Item) -> Array[Vector2i]:
	var occupied_cells: Array[Vector2i] = []
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			if item_grid[row][col] == item:
				occupied_cells.append(Vector2i(col, row))
	return occupied_cells


## get all items that are providing bonus to the given cells
func _get_affecting_items(cells: Array[Vector2i]) -> Array[Item]:
	var affecting_items: Array[Item] = []
	for cell in cells:
		for bonus: Item in bonus_providers[cell.y][cell.x]:
			if not affecting_items.has(bonus):
				affecting_items.append(bonus)
	return affecting_items


## get cells that given item is providing bonus to
func _get_affected_cells(item: Item) -> Array[Vector2i]:
	var affected_cells: Array[Vector2i] = []
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			var cell := Vector2i(col, row)
			@warning_ignore("unsafe_cast") # bonus_providers cant be typed properly
			if (bonus_providers[row][col] as Array).has(item) and not affected_cells.has(cell):
				affected_cells.append(cell)
	return affected_cells


## get items that are getting a bonus from provided cells
func _get_affected_items(cells: Array[Vector2i]) -> Array[Item]:
	var affected_items: Array[Item] = []
	for cell in cells:
		var item: Item = item_grid[cell.y][cell.x]
		if item != null and not affected_items.has(item):
			affected_items.append(item)
	return affected_items


## helper function because godot shows warning when performing integer division
func _position_to_cell(at_position: Vector2) -> Vector2i:
	var cell := Vector2i(
		floori(at_position.x / CELL_SIZE),
		floori(at_position.y / CELL_SIZE)
	)
	return cell
#endregion


#region Combat
func _on_item_used(action: CombatAction) -> void:
	item_used.emit(action)


func _on_combat_started(_combat_number: int) -> void:
	for item in items:
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.used.connect(_on_item_used)
		item.start()


func _on_combat_finished() -> void:
	for item in items:
		item.mouse_filter = Control.MOUSE_FILTER_STOP
		item.used.disconnect(_on_item_used)
		item.stop()
#endregion
