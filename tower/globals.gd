extends Node

var best_level := 0


func record_level(level: int) -> void:
	if level > best_level:
		best_level = level
