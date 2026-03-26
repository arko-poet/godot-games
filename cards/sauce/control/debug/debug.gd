extends VBoxContainer

var game_run: GameRun


func _on_add_hp_button_pressed() -> void:
	game_run.hp += 1


func _on_remove_hp_button_pressed() -> void:
	game_run.hp -= 1


func _on_add_mana_button_pressed() -> void:
	game_run.combat_encounter.mana += 1


func _on_remove_mana_button_pressed() -> void:
	game_run.combat_encounter.mana -= 1


func _on_draw_card_button_pressed() -> void:
	game_run.combat_encounter.draw_card()


func _on_damage_button_pressed() -> void:
	game_run.combat_encounter._attack(100)
