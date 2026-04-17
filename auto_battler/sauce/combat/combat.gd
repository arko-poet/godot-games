extends Control

signal started(combat_number: int)
signal finished

var combat_counter := 0

@onready var combat_button: Button = $CombatButton
@onready var player: Character = $"../Player"
@onready var enemy: Character = $"../Enemy"


func _on_inventory_item_used(action: CombatAction) -> void:
	_process_action(action)


func _on_combat_button_pressed() -> void:
	combat_counter += 1
	started.emit(combat_counter)
	combat_button.disabled = true


func _on_enemy_died() -> void:
	finished.emit()
	combat_button.disabled = false


func _on_enemy_acted(action: CombatAction) -> void:
	_process_action(action)


func _process_action(action: CombatAction) -> void:
	var target: Character
	match action.type:
		CombatAction.Type.BREAK:
			target = player if action.source is Enemy else enemy
			target.block -= action.value
		CombatAction.Type.ATTACK:
			target = player if action.source == enemy else enemy
			target.hit(action.value)
		CombatAction.Type.HEAL:
			target = enemy if action.source == enemy else player
			target.hp += action.value
		CombatAction.Type.BLOCK:
			target = enemy if action.source == enemy else player
			target.block += action.value
		_:
			push_error("Unknown CombatAction.Type")

	LogManager.log_action(action)
