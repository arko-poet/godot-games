extends Control


signal next_level


func _on_next_level_pressed() -> void:
	next_level.emit()
