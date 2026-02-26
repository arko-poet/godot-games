extends Node

@onready var tower : Tower = $Tower
@onready var hud : HUD = $HUD
@onready var player_death_sound : AudioStreamPlayer = $PlayerDeathSound

func _on_tower_player_fell_off() -> void:
	player_death_sound.play()
	await player_death_sound.finished
	AudioManager.free_players()
	Globals.record_level(tower.level)
	get_tree().reload_current_scene()
	

func _process(_delta: float) -> void:
	hud.update_level(tower.level)
	hud.update_time_left(tower.get_time_left())
