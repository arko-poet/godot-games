@abstract
class_name Character extends Control

signal died

@export_range(1, 1000) var max_hp: int

var hp: int:
	set(val):
		hp = min(max_hp, max(val, 0))
		hp_bar.max_value = max_hp
		hp_bar.value = hp
		hp_label.text = "%s / %s" % [hp, max_hp]
		if hp == 0:
			died.emit()

var block := 0:
	set(val):
		block = max(val, 0)
		if block == 0:
			armour_label.hide()
		else:
			armour_label.text = "B:%s" % block
			armour_label.show()
		
@onready var hp_bar: ProgressBar = $HPBar
@onready var hp_label: Label = $HPBar/HPLabel
@onready var armour_label: Label = $ArmourLabel


func _ready() -> void:
	assert(max_hp > 0)
	hp = max_hp


func hit(damage: int) -> void:
	var damage_left: int = max(0, damage - block)
	block -= damage
	hp -= damage_left
