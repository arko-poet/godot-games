extends Node

@onready var tower : Tower = $Tower
@onready var hud : HUD = $HUD

func _on_tower_player_fell_off() -> void:
	AudioManager.free_players()
	Globals.record_level(tower.level)
	get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	hud.set_level(tower.level)
