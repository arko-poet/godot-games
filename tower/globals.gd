extends Node

var best_level := 0
var best_combo := 0


func record_level(level: int) -> void:
	if level > best_level:
		best_level = level

func record_combo(combo : int) -> void:
	if combo > best_combo:
		best_combo = combo
