extends Node

@onready var tower : Tower = $Tower


func _on_tower_player_fell_off() -> void:
	AudioManager.free_players()
	get_tree().reload_current_scene()
