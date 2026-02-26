class_name Floor
extends StaticBody2D

var size: Vector2 ## size of Sprite and Collision
var _level : int

@onready var collision : CollisionShape2D = $Collision
@onready var sprite : Sprite2D = $Sprite


func set_size(size_: Vector2) -> void:
	sprite.scale = size_ / sprite.texture.get_size()
	collision.shape.size = size_
	self.size = size_


func set_level(l: int) -> void:
	_level = l
	_set_color()


func get_level() -> int:
	return _level


func _set_color() -> void:
	if _level < 50:
		sprite.material.set_shader_parameter("fill_color", Color.MEDIUM_SLATE_BLUE)
	elif _level < 100:
		sprite.material.set_shader_parameter("fill_color", Color.MEDIUM_PURPLE)
	else:
		sprite.material.set_shader_parameter("fill_color", Color.PALE_VIOLET_RED)
