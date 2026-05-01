extends ColorRect

signal play_again

func _on_play_button_pressed() -> void:
	play_again.emit()
