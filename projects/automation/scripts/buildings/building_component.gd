class_name BuildingComponent extends Node2D

signal timeout

@export var texture: Texture2D
@export var production_time: float = 1.0
@export_range(0, INT32_MAX) var footprint_size: int = 0

@onready var _sprite: Sprite2D = $Sprite
@onready var _production_timer: Timer = $ProductionTimer


func _ready() -> void:
	_sprite.texture = texture
	_production_timer.wait_time = production_time


func activate() -> void:
	_production_timer.start()


func _on_production_timer_timeout() -> void:
	timeout.emit()
