extends Character

signal attacked(damage: int)

const HP_SCALING := 10
const DAMAGE_SCALING := 1

var attack_damage := 1

@onready var attack_timer: Timer = $AttackTimer


func _on_attack_timer_timeout() -> void:
	attacked.emit(attack_damage)


func _on_combat_started() -> void:
	show()
	attack_timer.start()


func _on_combat_finished() -> void:
	attack_timer.stop()
	hide()
	attack_damage += 1
	max_hp += HP_SCALING
	hp = max_hp
