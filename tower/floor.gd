class_name Floor
extends StaticBody2D

var size: Vector2

func set_size(size_: Vector2) -> void:
	$Sprite.scale = size_
	$Collision.shape.size = size_
	self.size = size_
