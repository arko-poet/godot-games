extends Node

@export var achievement_scene: PackedScene


func unlock_achievement(achievement_name: String) -> void:
	var ft := achievement_scene.instantiate()
	match achievement_name:
		"10 grandmas":
			ft.set_achievement_properties(achievement_name, "res://sprites/grandma.png")
		"10 clicks":
			ft.set_achievement_properties(achievement_name, "res://sprites/cookie.png")
	get_parent().add_child(ft)
