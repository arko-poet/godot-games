extends Node

@onready var tower : Tower = $Tower
@onready var hud : HUD = $HUD

func _on_tower_player_fell_off() -> void:
	$PlayerDeathSound.play()
	await $PlayerDeathSound.finished
	AudioManager.free_players()
	Globals.record_level(tower.level)
	get_tree().reload_current_scene()
	

func _process(_delta: float) -> void:
	hud.update_level(tower.level)
	hud.update_time_left(tower.get_time_left())
