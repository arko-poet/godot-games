class_name BuildingComponent extends Node2D

signal item_created(item: Item)

@export_range(0, INT32_MAX) var footprint_size: int = 0

var center_cell: Vector2i
