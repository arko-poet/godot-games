extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VolumeControl.value = AudioManager.global_volume


func _on_volume_control_drag_ended(_value_changed: bool) -> void:
	AudioManager.set_global_volume($VolumeControl.value)
