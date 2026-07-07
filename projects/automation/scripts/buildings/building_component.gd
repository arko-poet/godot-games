class_name BuildingComponent extends Node2D

signal timeout
signal item_created(item: Item)

const ItemScene := preload("res://scenes/item.tscn")

@export var texture: Texture2D
@export var production_time: float = 1.0
@export_range(0, INT32_MAX) var footprint_size: int = 0

var storage: Dictionary[Resources.Type, int]

var center_cell: Vector2i

@onready var _sprite: Sprite2D = $Sprite
@onready var _production_timer: Timer = $ProductionTimer


func _ready() -> void:
	_sprite.texture = texture
	_production_timer.wait_time = production_time


func activate() -> void:
	_production_timer.start()


func store_item(item: Item) -> void:
	storage[item.resource] = storage.get(item.resource, 0) + 1
	item.queue_free()


func get_stored_item() -> Item:
	for resource in storage:
		if storage[resource] > 0:
			var item: Item = ItemScene.instantiate()
			item.resource = resource
			storage[resource] -= 1
			return item
	
	push_error("Attempt to get stored item on empty storage")
	return null


func has_stored_items() -> bool:
	for resource in storage:
		if storage[resource] > 0:
			return true
	
	return false


func _on_production_timer_timeout() -> void:
	timeout.emit()
