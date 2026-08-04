class_name Building
extends Node2D

const DIRECTIONS := [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]
const _RIGHT_ANGLE := TAU / 4.0

@export_range(0, INT32_MAX) var footprint_size: int = 0

var center_cell: Vector2i


func get_direction() -> Vector2i:
	return DIRECTIONS[int(round(rotation / _RIGHT_ANGLE)) % 4]
