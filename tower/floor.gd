class_name Floor
extends StaticBody2D

var size: Vector2 ## size of Sprite and Collision
var level : int

@onready var collision : CollisionShape2D = $Collision
@onready var sprite : Sprite2D = $Sprite


func _ready():
	collision.shape = RectangleShape2D.new()


func set_size(size_: Vector2) -> void:
	print(sprite.texture.get_size())
	sprite.scale = size_ / sprite.texture.get_size()
	collision.shape.size = size_
	#$CenterContainer/NinePatchRect.size = size_
	self.size = size_
