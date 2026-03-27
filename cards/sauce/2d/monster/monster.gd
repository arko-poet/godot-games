class_name Monster
extends Node2D

signal monster_died
signal player_attacked(damage: int)

@export_range(0, 1000) var max_hp: int
@export_range(0, 100) var damage: int

var hp: int:
	set(value):
		hp = min(max(0, value), max_hp)
		hp_bar.max_value = max_hp
		var t = create_tween()
		t.tween_property(hp_bar, "value", value, 0.2)
		hp_label.text = "%s / %s" % [hp, max_hp]
		if hp == 0:
			monster_died.emit()

@onready var hp_bar: ProgressBar = $HPBar
@onready var hp_label: Label = $HPLabel
@onready var model: CanvasGroup = $Model


func _ready() -> void:
	hp = max_hp


func monster_turn() -> void:
	print("attack")
	_attack()


func _attack() -> void:
	emit_signal("player_attacked", damage)
	
