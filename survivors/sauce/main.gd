extends Node

@onready var world: Node2D = $World
@onready var player: Player = $World/Player
@onready var hud: HUD = $HUDLayer/HUD
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound


func _ready():
	world.process_mode = Node.PROCESS_MODE_DISABLED
	_show_level_up()


func _on_world_game_over() -> void:
	world.process_mode = Node.PROCESS_MODE_DISABLED
	hud.switch_gg_label(true)
	game_over_sound.finished.connect(get_tree().reload_current_scene)
	game_over_sound.play()


func _on_player_hp_changed() -> void:
	hud.set_hp(player.hp, player.max_hp)


func _on_player_level_changed() -> void:
	hud.set_level(player.level)
	call_deferred("_show_level_up")


func _show_level_up() -> void:
	world.process_mode = Node.PROCESS_MODE_DISABLED
	hud.get_upgrades()


func _on_player_xp_changed() -> void:
	hud.set_xp(player.xp, player.next_level_xp)


func _on_world_kill_count_changed() -> void:
	hud.set_kill_count(world.kill_count)


func _on_hud_upgrade_chosen(upgrade: int) -> void:
	print(upgrade)
	world.process_mode = Node.PROCESS_MODE_ALWAYS
