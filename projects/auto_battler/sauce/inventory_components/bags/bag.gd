class_name Bag extends InventoryComponent


@export_range(1, Inventory.INVENTORY_SIZE) var columns: int = 1
@export_range(1, Inventory.INVENTORY_SIZE) var rows: int = 1
#@export var bg_color: Color = Color("#6B3F1E")
#@export var border_color: Color = Color("#C4955A")

## items which are partially contained in the bag
var partial_items: Array[Item]
## items which are fully contained in the bag with the top left cell they occupy
var full_items: Dictionary[Item, Vector2i]

@onready var sprite: TextureRect = $Sprite


func _ready() -> void:
	custom_minimum_size = Vector2(columns, rows) * Inventory.CELL_SIZE
	for row in rows:
		for column in columns:
			var cell := Vector2i(column, row)
			footprint.append(cell)
	queue_redraw()

# DEPRECATED - use actual textures instead
#func _draw() -> void:
	#for row in rows:
		#for column in columns:
			#var cell := Vector2i(column, row)
			#var cell_size := Vector2i(Inventory.CELL_SIZE, Inventory.CELL_SIZE)
			#var rect2i := Rect2i(cell * Inventory.CELL_SIZE, cell_size)
			#draw_rect(rect2i, bg_color)
			#draw_rect(rect2i, border_color, false, 1)


func _show_component() -> void:
	show()
	for item in full_items: item.show()


func clear_items() -> void:
	partial_items.clear()
	full_items.clear()


func rotate() -> void:
	for item in full_items:
		item.rotate()
		full_items[item] = Vector2i(-full_items[item].y, full_items[item].x)
	
	super.rotate()


func _unrotate() -> void:
	var rotation_counter_copy: int = rotation_counter
	while rotation_counter_copy > 0:
		rotation_counter_copy -= 1
		
		for item in full_items:
			item._unrotate()
			full_items[item] = Vector2i(full_items[item].y, -full_items[item].x)
	
	super._unrotate()


## return visual top left corner of the Item while respecting rotation
func get_top_left_corner() -> Vector2:
	var local_transform := Transform2D(rotation, Vector2.ZERO)
	var local_rect := Rect2(Vector2.ZERO, get_rect().size)
	return (local_transform * local_rect).position


func _should_not_start_dragging(event: InputEventMouseButton) -> bool:
	return event.button_index != MOUSE_BUTTON_LEFT or not partial_items.is_empty()


func _start_dragging() -> void:
	super._start_dragging()
	for item in full_items:
		item.hide()


func _create_drag_preview(preview_position: Vector2) -> Control:
	var dup_bag: Bag = duplicate()
	#dup_bag.position = -preview_position
	dup_bag.position = - dup_bag.size / 2
	dup_bag.rotation = rotation
	#dup_bag.pivot_offset = preview_position
	dup_bag.pivot_offset = dup_bag.size / 2
	dup_bag.show()

	var preview := Control.new()
	preview.add_child(dup_bag)
	
	for item in full_items:
		var dup_item: Item = item.duplicate()
		dup_item.rotation = item.rotation
		# calculate item preview position relative to preview
		# not fully sure how this works but it seems that
		# Transform2D represents how to map points from one set of coordinates to other set
		# e.g. item.get_transform() tells how to map point in item to point in its parent
		# transforms seem to be applied backwards I think cause of matrix maths or something
		# so point in item -> point in item parent (e.g. inventory) ->
		# -> point in child of bag parent (bag) -> point in preview display
		var item_to_bag := get_transform().inverse() * item.get_transform()
		var item_to_dup_bag := dup_bag.get_transform() * item_to_bag
		dup_item.position = item_to_dup_bag.origin

		preview.add_child(dup_item)
	
	return preview


func _create_drag_data(drag_preview: Control, preview_position: Vector2) -> Dictionary:
	return {
		"inventory_component": self,
		"offset": preview_position * Transform2D(-rotation, Vector2.ZERO),
		"items": full_items.keys(),
		#"cell_held": _get_cell_held(preview_position),
		"cell_held": _get_cell_held(sprite.size / 2),
		"preview": drag_preview
	}


func _get_cell_held(held_position: Vector2) -> Vector2i:
	var lmp := held_position / Inventory.CELL_SIZE
	return Vector2i(lmp * Transform2D(-rotation, Vector2.ZERO))
