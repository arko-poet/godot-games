extends Node


func _on_tower_player_fell_off() -> void:
	get_tree().reload_current_scene()
