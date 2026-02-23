class_name Floor
extends StaticBody2D

var size: Vector2 ## size of Sprite and Collision
@onready var collision : CollisionShape2D = $Collision
@onready var sprite : Sprite2D = $Sprite


func _ready():
	collision.shape = RectangleShape2D.new()


func set_size(size_: Vector2) -> void:
	sprite.scale = size_
	collision.shape.size = size_
	self.size = size_
