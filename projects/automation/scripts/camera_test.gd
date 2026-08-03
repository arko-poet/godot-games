extends Camera2D

@onready var camera: Camera2D = %Camera


func _process(_delta: float) -> void:
	print('---')
	print(camera.position)
	print(position)
	position = (camera.position / 20) * 1.6
