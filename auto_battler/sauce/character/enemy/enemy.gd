class_name Enemy
extends Character

signal acted(action: CombatAction)

const HP_SCALING := 10
const DAMAGE_SCALING := 1
const BLOCK_SCALING := 1
const START_BLOCKING := 5

var attack_damage := 0
var block_generation := 1
var display_name := "Enemy"

@onready var attack_timer: Timer = $AttackTimer
@onready var block_timer: Timer = $BlockTimer


func _on_attack_timer_timeout() -> void:
	acted.emit(CombatAction.new(CombatAction.Type.ATTACK, attack_damage, self))


func _on_combat_started(combat_number: int) -> void:
	# initialise stats
	attack_damage += DAMAGE_SCALING
	max_hp += HP_SCALING
	hp = max_hp
	
	# start timers
	attack_timer.start()
	if combat_number >= 2:
		block_generation += BLOCK_SCALING
		block_timer.start()
	
	show()


func _on_combat_finished() -> void:
	attack_timer.stop()
	block_timer.stop()
	hide()


func _on_block_timer_timeout() -> void:
	acted.emit(CombatAction.new(CombatAction.Type.BLOCK, block_generation, self))
