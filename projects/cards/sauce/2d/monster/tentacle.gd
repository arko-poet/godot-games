extends Monster


func monster_turn() -> void:
	turn += 1
	block += turn
	_attack()
	turn_finished.emit()
