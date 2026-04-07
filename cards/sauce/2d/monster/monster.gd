class_name Monster
extends Node2D

signal monster_died
signal monster_acted(actions: Array[Action])
signal turn_finished

@export_range(0, 1000) var max_hp: int
@export_range(0, 100) var damage: int
@export var animations: AnimationPlayer

var hp: int:
	set(value):
		hp = min(max(0, value), max_hp)
		hp_bar.max_value = max_hp
		var hp_t = create_tween()
		hp_t.tween_property(hp_bar, ^"value", value, 0.2)
		hp_label.text = "%s / %s" % [hp, max_hp]
		if hp == 0:
			monster_died.emit()
			var death_t := create_tween()
			death_t.finished.connect(queue_free)
			death_t.tween_property(model, ^"self_modulate:a", 0, 0.5)
var block := 0
var turn := 0
var strength := 0
var combat_num: int

@onready var hp_bar: ProgressBar = $HPBar
@onready var hp_label: Label = $HPLabel
@onready var model: CanvasGroup = $Model


func _ready() -> void:
	max_hp += 10 * combat_num
	hp = max_hp
	damage += combat_num


func hit(hit_damage: int) -> void:
	var damage_left = max(0, hit_damage - block)
	block = max(0, block - hit_damage)
	hp -= damage_left


func monster_turn() -> void:
	_attack()
	turn_finished.emit()


func _attack() -> void:
	animations.play(&"attack")
	await animations.animation_finished
	animations.play(&"idle")
	
	var action := Action.new()
	action.type = Action.Type.ATTACK
	action.value = damage + strength
	action.monster_action = true
	var actions: Array[Action] = []
	actions.append(action)
	monster_acted.emit(actions)
