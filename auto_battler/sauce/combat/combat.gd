extends Control

signal started(combat_number: int)
signal finished

var combat_counter := 0

@onready var combat_button: Button = $CombatButton
@onready var player: Character = $"../Player"
@onready var enemy: Character = $"../Enemy"


func _on_inventory_item_used(effect: Dictionary) -> void:
	var block_damage: int = effect.get("block_damage", 0)
	enemy.block -= block_damage
	
	var attack_damage: int = effect.get("attack_damage", 0)
	enemy.hit(attack_damage)
	
	var heal: int = effect.get("heal", 0)
	player.hp += heal
	LogManager.log_action()

func _on_combat_button_pressed() -> void:
	combat_counter += 1
	started.emit(combat_counter)
	combat_button.disabled = true


func _on_enemy_died() -> void:
	finished.emit()
	combat_button.disabled = false


func _on_enemy_attacked(damage: int) -> void:
	player.hit(damage)
