class_name Building
extends Node2D

const _DIRECTIONS := [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]

@export_range(0, INT32_MAX) var footprint_size: int = 0

var center_cell: Vector2i


func get_direction() -> Vector2i:
	return _DIRECTIONS[int(round(rotation / (TAU / 4.0))) % 4]
