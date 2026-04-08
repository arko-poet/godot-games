extends Control

const INVENTORY_SIZE := 8 ## height and width in number of cells
const CELL_SIZE := Vector2i(16, 16)
const BORDER_COLOR := Color("#5A6270")
const CELL_BG := Color("#252A33")


func _draw():
	# inventory grid
	for y in range(INVENTORY_SIZE):
		for x in range(INVENTORY_SIZE):
			var cell_position := Vector2i(x * CELL_SIZE.x, y * CELL_SIZE.y)
			draw_rect(Rect2i(cell_position, CELL_SIZE), CELL_BG)
			draw_rect(Rect2i(cell_position, CELL_SIZE), BORDER_COLOR, false, 1)
