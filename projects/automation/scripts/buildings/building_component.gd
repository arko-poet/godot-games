class_name Building
extends Node2D

@export_range(0, INT32_MAX) var footprint_size: int = 0

var center_cell: Vector2i


func get_direction() -> Vector2i:
	var rotation_count := int(round(rotation / (TAU / 4.0))) % 4
	match rotation_count:
		0:
			return Vector2i.RIGHT
		1:
			return Vector2i.DOWN
		2:
			return Vector2i.LEFT
		3:
			return Vector2i.UP
		_:
			push_error("Invalid inserter direction")
			return Vector2i.RIGHT
