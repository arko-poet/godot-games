extends Control

signal start_new_game


func _on_try_again_button_pressed() -> void:
	start_new_game.emit()
