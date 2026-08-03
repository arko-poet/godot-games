extends Camera2D

@onready var camera: Camera2D = %Camera


func _process(_delta: float) -> void:
	position = camera.global_position / World.TILE_SIZE
