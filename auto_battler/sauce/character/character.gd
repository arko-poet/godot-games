class_name Character
extends Control

signal died

@export_range(1, 1000) var max_hp: int

var hp: int:
	set(val):
		hp = min(max_hp, max(val, 0))
		hp_bar.value = hp
		hp_bar.max_value = max_hp
		hp_label.text = "%s / %s" % [hp, max_hp]
		if hp == 0:
			died.emit()
		
@onready var hp_bar: ProgressBar = $HPBar
@onready var hp_label: Label = $HPBar/HPLabel


func _ready() -> void:
	assert(max_hp > 0)
	hp = max_hp
