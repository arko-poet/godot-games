extends Control

const INVENTORY_SIZE := 8 ## height and width in number of cells
const CELL_SIZE := Vector2i(16, 16)
const BORDER_COLOR := Color("#5A6270")
const BG_COLOR := Color("#252A33")


func _ready() -> void:
	custom_minimum_size = Vector2i(CELL_SIZE * INVENTORY_SIZE)


func _draw():
	# inventory grid
	for y in range(INVENTORY_SIZE):
		for x in range(INVENTORY_SIZE):
			var cell_position := Vector2i(x * CELL_SIZE.x, y * CELL_SIZE.y)
			var rect2i := Rect2i(cell_position, CELL_SIZE)
			draw_rect(rect2i, BG_COLOR)
			draw_rect(rect2i, BORDER_COLOR, false, 1)


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	assert(data is Dictionary)
	assert("item" in data)
	
	var offset: Vector2 = data["offset"]
	var item: Item = data["item"]
	item.position = at_position + position + offset
