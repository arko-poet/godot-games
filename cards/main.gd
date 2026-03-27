extends Node

@onready var world: World = $World
@onready var game_run: GameRun = $UI/GameRun


func _ready() -> void:
	game_run.next_encounter(world.monster)


func _on_world_enemies_defeated() -> void:
	game_run.combat_finished()


func _on_game_run_rewards_claimed() -> void:
	game_run.next_encounter(world.new_monster())
