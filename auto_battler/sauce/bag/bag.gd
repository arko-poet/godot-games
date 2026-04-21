@tool class_name Bag extends Control

@export_range(1, Inventory.INVENTORY_SIZE) var columns: int = 1
@export_range(1, Inventory.INVENTORY_SIZE) var rows: int = 1
@export var bg_color: Color = Color("#6B3F1E")
@export var border_color: Color = Color("#C4955A")

var footprint: Array[Vector2i]
var items: Dictionary[Vector2i, Item]


func _ready() -> void:
	custom_minimum_size = Vector2(columns, rows) * Inventory.CELL_SIZE
	for row in rows:
		for column in columns:
			var cell := Vector2i(column, row)
			footprint.append(cell)
			items[cell] = null
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
