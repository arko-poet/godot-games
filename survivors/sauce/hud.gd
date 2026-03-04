class_name HUD
extends Control


@onready var hp_bar: ProgressBar = $HPBar
@onready var xp_bar: ProgressBar = $XPBar
@onready var level_label: Label = $LevelLabel


func set_hp(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp


func set_xp(xp: int, max_xp: int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = xp


func set_level(level: int) -> void:
	level_label.text = "Level: %s" % level
