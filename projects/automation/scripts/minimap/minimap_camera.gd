extends Camera2D


@onready var camera: Camera2D = %Camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = camera.position
