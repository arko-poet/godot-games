extends Node

@onready var world: Node2D = $World
@onready var player: Player = $World/Player
@onready var hud: HUD = $HUDLayer/HUD


#func _process(_delta):
	#print(Engine.get_frames_per_second())


func _on_world_game_over() -> void:
	get_tree().reload_current_scene()


func _on_player_hp_changed() -> void:
	hud.set_hp(player.hp, player.max_hp)


func _on_player_level_changed() -> void:
	hud.set_level(player.level)


func _on_player_xp_changed() -> void:
	hud.set_xp(player.xp, player.next_level_xp)


func _on_world_kill_count_changed() -> void:
	hud.set_kill_count(world.kill_count)
