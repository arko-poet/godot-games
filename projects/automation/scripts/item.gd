class_name Item extends Node2D

signal item_moved(item: Item, from: Vector2i, to: Vector2i)

const _SPRITE_PATH := "res://art/sprites/resources/mined/%s.png"
const _RESOURCE_TO_SPRITE_NAME := {
	Resources.Type.COAL: "coal",
	Resources.Type.COPPER: "copper",
	Resources.Type.SILVER: "silver"
}

var cell: Vector2i:
	set(value):
		var original_cell := cell
		cell = value
		item_moved.emit(self, original_cell, cell)


var resource: Resources.Type:
	set(value):
		resource = value
		if _sprite:
			_sprite.texture = load(_SPRITE_PATH % _RESOURCE_TO_SPRITE_NAME[resource])

@onready var _sprite: Sprite2D = $Sprite


func _ready() -> void:
	resource = resource
