extends Monster


func monster_turn() -> void:
	turn += 1
	strength += 1
	_attack()
	turn_finished.emit()
