extends Control

signal started
signal finished

@onready var combat_button: Button = $CombatButton
@onready var player: Character = $"../Player"
@onready var enemy: Character = $"../Enemy"


func _on_inventory_item_used(effect: Dictionary) -> void:
	var damage: int = effect.get("attack", 0)
	enemy.hp -= damage


func _on_combat_button_pressed() -> void:
	started.emit()
	combat_button.disabled = true


func _on_enemy_died() -> void:
	finished.emit()
	combat_button.disabled = false


func _on_enemy_attacked(damage: int) -> void:
	player.hp -= damage
