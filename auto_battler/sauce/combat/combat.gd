extends Control

signal combat_started
signal combat_finished

@onready var combat_button: Button = $CombatButton


func _on_inventory_item_used(effect: Dictionary) -> void:
	# TODO apply item effect
	print(effect)


func _on_combat_button_pressed() -> void:
	combat_started.emit()
	combat_button.disabled = true


func _on_player_died() -> void:
	combat_finished.emit()
	combat_button.disabled = false


func _on_enemy_died() -> void:
	combat_finished.emit()
	combat_button.disabled = false
