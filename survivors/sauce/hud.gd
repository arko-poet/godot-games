class_name HUD
extends Control


@onready var hp_bar: ProgressBar = $HPBar


func set_hp(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
