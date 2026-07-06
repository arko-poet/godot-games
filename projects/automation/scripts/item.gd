class_name Item extends Node2D

signal item_moved(from: Vector2, to: Vector2)

const _SPRITE_PATH := "res://art/sprites/resources/mined/%s.png"
const _RESOURCE_TO_SPRITE_NAME := {
	Resources.Type.COAL: "coal",
	Resources.Type.COPPER: "copper",
	Resources.Type.SILVER: "silver"
}

var resource: Resources.Type:
	set(value):
		resource = value
		_sprite.texture = load(_SPRITE_PATH % _RESOURCE_TO_SPRITE_NAME[resource])

@onready var _sprite: Sprite2D = $Sprite


func move(destination: Vector2) -> void:
	var from := position
	position = destination
	item_moved.emit(from, destination)
