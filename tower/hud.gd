extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_control_drag_ended(value_changed: bool) -> void:
	AudioManager.set_global_volume($VolumeControl.value)
	print(AudioManager.global_volume)
