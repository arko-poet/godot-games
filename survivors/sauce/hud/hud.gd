class_name HUD
extends Control

signal upgrade_chosen(upgrade: Upgrade)

@onready var hp_bar: ProgressBar = $HPBar
@onready var xp_bar: ProgressBar = $XPBar
@onready var level_label: Label = $LevelLabel
@onready var kill_count_label: Label = $KillCount/Label
@onready var gg_label: Label = $GGLabel
@onready var upgrade_menu: Control = $UpgradeMenu


func _ready() -> void:
	switch_gg_label(false)
	upgrade_menu.hide()


func set_hp(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp


func set_xp(xp: int, max_xp: int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = xp


func set_level(level: int) -> void:
	level_label.text = "Level: %s" % level


func set_kill_count(count: int) -> void:
	kill_count_label.text = "%s" % count
	

func switch_gg_label(show_: bool):
	if show_:
		gg_label.show()
	else:
		gg_label.hide()


func show_upgrades(upgrades: Array[Upgrade]) -> void:
	upgrade_menu.set_upgrades(upgrades)
	upgrade_menu.show()


func _on_upgrade_menu_upgrade_chosen(upgrade: Upgrade) -> void:
	upgrade_menu.hide()
	emit_signal("upgrade_chosen", upgrade)
