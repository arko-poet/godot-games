class_name Item extends Node2D

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
