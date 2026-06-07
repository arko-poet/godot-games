@tool
class_name Inventory extends Control

signal item_used(action: CombatAction)
signal item_added(item: Item)
signal item_removed(item: Item)
signal bag_removed(bag: Bag)

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


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	assert(data is Dictionary)
		
	var component: InventoryComponent = data["inventory_component"]
	var is_item := component is Item
	var cell_held = data["cell_held"]
	
	# check if cursor moved to other cell in which case hovered cells changed -> redraw needed
	var redraw_needed := false
	var hovered_cell := _position_to_cell(at_position)
	if hovered_cell != last_hovered_cell or hovered_cells.is_empty() or update_rotation:
		update_rotation = false
		redraw_needed = true
		
		# update hovered cells
		hovered_cells.clear()
		for component_cell in component.footprint:
			var cell: Vector2i = component_cell + hovered_cell - cell_held 
			if is_item:
				if _is_cell_in_inventory(cell) and bag_grid[cell.y][cell.x] != null:
					hovered_cells.append(cell)
			else:
				hovered_cells.append(cell)
		last_hovered_cell = hovered_cell
		
		# update bonus cells
		if is_item:
			hovered_bonus_cells.clear()
			for item_cell in component.bonus_cells:
				var bonus_cell: Vector2i = hovered_cell + item_cell - cell_held
				if _is_cell_in_inventory(bonus_cell):
					hovered_bonus_cells.append(bonus_cell)
	
	# can component be placed where its hovering
	var can_drop: bool = true
	if is_item and component.footprint.size() != hovered_cells.size():
		can_drop = false
	for hc in hovered_cells:
		if not _is_cell_in_inventory(hc):
			can_drop = false
			break
	
	if redraw_needed:
		hover_color = CAN_DROP_BG_COLOR if can_drop else CANT_DROP_BG_COLOR
		queue_redraw()
		
	return can_drop

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var ic: InventoryComponent = data.get("inventory_component", null)
	var is_item := ic is Item
	
	if is_item:
		for bag in bags:
			bag.full_items.erase(ic)
			bag.partial_items.erase(ic)

	_clear_hovered_components(ic)
		 
	if (is_item and items.has(ic)) or (not is_item and bags.has(ic)): _move_component(ic)
	else: _add_component(ic)

	hovered_cells.clear()
	hovered_bonus_cells.clear()


func remove_item(item: Item) -> void:
	_remove_bonuses(item)
	for bag in bags:
		bag.full_items.erase(item)
		bag.partial_items.erase(item)
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			if item == item_grid[row][col]:
				items.erase(item)
				item_grid[row][col] = null
	item_removed.emit(item)


func remove_bag(bag: Bag) -> void:
	for row in INVENTORY_SIZE:
		for col in INVENTORY_SIZE:
			if bag == bag_grid[row][col]:
				bags.erase(bag)
				bag_grid[row][col] = null
	
	for item in bag.full_items:
		remove_item(item)
	for item in bag.partial_items:
		remove_item(item)
	bag.clear_items()
	bag.z_index = 0
	bag_removed.emit(bag)
	

func rotate_hovered_cells() -> void:
	update_rotation = true
	_can_drop_data(get_local_mouse_position(), get_viewport().gui_get_drag_data())


func _on_mouse_exited() -> void:
	if get_viewport().gui_is_dragging():
		hovered_cells.clear()
		hovered_bonus_cells.clear()
		queue_redraw()


func _add_component(component: InventoryComponent) -> void:
	component.reparent(self)
	if component is Item:
		_place_item(component)
		items.append(component)
		item_added.emit(component)
	else:
		_place_bag(component)
		bags.append(component)
		

func _place_item(item: Item) -> void:
	# without this check item would be palced outside of grid
	if hovered_cells.is_empty():
		return
		
	var top_left_cell := _get_top_left_cell(hovered_cells)
	
	var hovered_bags: Array[Bag] = []
	for cell in hovered_cells:
		item_grid[cell.y][cell.x] = item
		
		var bag: Bag = bag_grid[cell.y][cell.x]
		if not hovered_bags.has(bag) and bag != null:
			hovered_bags.append(bag)
			
	
	for hb in hovered_bags:
		if hovered_bags.size() == 1:
			# find bag position
			var bag_top_left_cell := Vector2i(INVENTORY_SIZE, INVENTORY_SIZE)
			for row in INVENTORY_SIZE:
				for column in INVENTORY_SIZE:
					if bag_grid[row][column] == hb:
						bag_top_left_cell = Vector2i(min(bag_top_left_cell.x, column), min(bag_top_left_cell.y, row))

			var min_item_offset := _get_top_left_cell(item.footprint)
			var item_origin := top_left_cell - min_item_offset
			var min_bag_offset := _get_top_left_cell(hb.footprint)
			
			hb.full_items[item] = item_origin - (bag_top_left_cell - min_bag_offset)
		else:
			hb.partial_items.append(item)
	
	item.position = Vector2(top_left_cell) * CELL_SIZE - item.get_top_left_corner()
	item.move_to_front()
	
	for bc in hovered_bonus_cells:
		assert(item not in bonus_providers[bc.y][bc.x])
		@warning_ignore("unsafe_cast") # bonus_providers can't be typed properly
		(bonus_providers[bc.y][bc.x] as Array).append(item)
	
	_apply_bonuses(item)
	item.show()
	queue_redraw()


func _move_component(component: InventoryComponent) -> void:
	var is_item := component is Item
	
	if is_item: _remove_bonuses(component)
	
	var grid := item_grid if is_item else bag_grid
	for row in grid:
		for col_i in INVENTORY_SIZE:
			if component == row[col_i]:
				row[col_i] = null
	
	if is_item: _place_item(component)
	else: _place_bag(component)


func _place_bag(bag: Bag) -> void:
	# without this check bag could end up outside of the inventory
	if hovered_cells.is_empty():
		return
		
	var top_left_cell := _get_top_left_cell(hovered_cells)
	
	for hc in hovered_cells:
		bag_grid[hc.y][hc.x] = bag
	
	bag.position = Vector2(top_left_cell) * CELL_SIZE - bag.get_top_left_corner()
	bag.z_index = -1
		
	var min_bag_footprint := _get_top_left_cell(bag.footprint)
	
	for item in bag.full_items:
		hovered_cells.clear()
		for cell in item.footprint:
			# computes cells that are going to be occupied by the item in the inventory grid
			# top_left_cell is the top left inventory cell that bag is occupying
			# bag.full_items[item] which cell in bag the item is occupying
			# min_bag_footprint is to adjust for bag rotations
			hovered_cells.append(cell + top_left_cell + bag.full_items[item] - min_bag_footprint)
			
		_move_component(item)
	
	bag.show()
	queue_redraw()


## remove components present in hovered cells except the specified one (the one dragging)
func _clear_hovered_components(except_component: InventoryComponent) -> void:
	var overlapping_components: Array[InventoryComponent] = []
	var is_item := except_component is Item
	
	for hc in hovered_cells:
		var component: InventoryComponent = item_grid[hc.y][hc.x] 
		if is_item: component = item_grid[hc.y][hc.x] 
		else: component = bag_grid[hc.y][hc.x]
		
		if component != null and component not in overlapping_components:
			overlapping_components.append(component)
	
	overlapping_components.erase(except_component)
	for oc in overlapping_components:
		if is_item: remove_item(oc)
		else: remove_bag(oc)


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
	

func _is_cell_in_inventory(cell: Vector2i) -> bool:
	return (
		cell.y >= 0 and cell.x >= 0
		and cell.y < INVENTORY_SIZE and cell.x < INVENTORY_SIZE
	)
	
	
func _get_top_left_cell(cells: Array[Vector2i]) -> Vector2i:
	var top_left_cell := Vector2i(INVENTORY_SIZE, INVENTORY_SIZE)
		
	for c in cells:
		top_left_cell = Vector2i(min(top_left_cell.x, c.x), min(top_left_cell.y, c.y))
	
	return top_left_cell	
#endregion


#region Combat
func _on_item_used(action: CombatAction) -> void:
	item_used.emit(action)


func _on_combat_started(_combat_number: int) -> void:
	for item in items:
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item.used.connect(_on_item_used)
		item.start()
	
	for bag in bags:
		bag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		

func _on_combat_finished() -> void:
	for item in items:
		item.mouse_filter = Control.MOUSE_FILTER_PASS
		item.used.disconnect(_on_item_used)
		item.stop()
		
	for bag in bags:
		bag.mouse_filter = Control.MOUSE_FILTER_PASS
#endregion
