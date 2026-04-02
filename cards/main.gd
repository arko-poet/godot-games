extends Node

@onready var world: World = $World
@onready var game_run: GameRun = $UI/GameRun
@onready var curtain: ColorRect = $UI/Curtain


func _ready() -> void:
	game_run.next_encounter(world.monster)


func _on_world_enemies_defeated() -> void:
	game_run.combat_finished()


func _on_world_player_attacked(damage: int) -> void:
	game_run.combat_encounter.hit_player(damage)


func _on_game_run_encounter_finished() -> void:
	curtain.show()
	
	var t := create_tween()
	t.tween_property(curtain, ^"modulate:a", 1.0, 0.8)
	await t.finished
	_new_encounter()
	
	t = create_tween()
	t.tween_interval(0.4)
	t.tween_property(curtain, ^"modulate:a", 0.0, 0.8)
	t.finished.connect(curtain.hide)


func _new_encounter() -> void:
	var monster := world.spawn_monster(game_run.encounter_num + 1)
	game_run.next_encounter(monster)
	monster.monster_acted.connect(_on_monster_acted)


func _on_combat_encounter_monster_attacked(damage: int) -> void:
	world.character.attack()
	world.monster.hp -= damage


func _on_game_run_player_died() -> void:
	world.character.die()


func _on_character_player_died() -> void:
	get_tree().reload_current_scene()


func _on_monster_acted(actions: Array[Action]) -> void:
	var new_actions := game_run.relic_manager.process_actions(actions)
	game_run.execute_monster_actions(new_actions)
