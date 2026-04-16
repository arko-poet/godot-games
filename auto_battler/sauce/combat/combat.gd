extends Control

signal started(combat_number: int)
signal finished

var combat_counter := 0

@onready var combat_button: Button = $CombatButton
@onready var player: Character = $"../Player"
@onready var enemy: Character = $"../Enemy"


func _on_inventory_item_used(effect: Dictionary) -> void:
	_process_action(effect)


func _on_combat_button_pressed() -> void:
	combat_counter += 1
	started.emit(combat_counter)
	combat_button.disabled = true


func _on_enemy_died() -> void:
	finished.emit()
	combat_button.disabled = false


func _on_enemy_attacked(damage: int) -> void:
	player.hit(damage)


func _on_enemy_acted(effect: Dictionary) -> void:
	_process_action(effect)


func _process_action(effect: Dictionary) -> void:
	var target: Character
	if "block_damage" in effect:
		target = player if effect["producer"] == enemy else enemy
		target.block -= effect["block_damage"]
	
	if "attack_damage" in effect:
		target = player if effect["producer"] == enemy else enemy
		target.hit(effect["attack_damage"])
	
	if "heal" in effect:
		target = enemy if effect["producer"] == enemy else player
		target.hp += effect["heal"]
	
	if "block" in effect:
		target = enemy if effect["producer"] == enemy else player
		target.block += effect["block"]
	
	LogManager.log_action()
