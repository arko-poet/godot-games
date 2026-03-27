class_name Card
extends Control

signal card_entered(card: Card)
signal card_exited(card: Card)

const SHADOW_SIZE := 12

var properties: Dictionary
var cost: int:
	set(value):
		cost = value
		cost_label.text = "%s" % value
var actions: Dictionary
var playable := false:
	set(value):
		playable = value
		_switch_shadow(value)

@onready var cost_label: Label = $CostLabel
@onready var name_label: Label = $NameLabel
@onready var description_label: Label = $DescriptionLabel


func _ready() -> void:
	if not properties:
		return
	name_label.text = properties["name"]
	cost = int(properties["cost"])
	_set_description()


func _set_description() -> void:
	var description := ""
	actions = properties["actions"]
	for action in actions: ## TODO action order is not deterministic
		var val = int(actions[action]["value"])
		match action:
			"attack":
				if not "repeats" in actions[action]:
					description += "Deals %s damage. " % val
				else:
					var repeats = int(actions[action]["repeats"])
					description += "Deals %s damage %s times. " % [val, repeats]
			"block":
				description += "Adds %s block. " % val
			"draw":
				description += "Draw %s cards. " % val
			"heal":
				description += "Heals for %s. " % val
			"strength":
				description += "Increase strength by %s. " % val
			"max_hp":
				description += "Increase max hp by %s." % val
			_:
				push_error("unrecognised action name: %s" % action)
	description_label.text = description


func _on_mouse_entered() -> void:
	emit_signal("card_entered", self)


func _on_mouse_exited() -> void:
	emit_signal("card_exited", self)


func _switch_shadow(on: bool) -> void:
	var sb: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	sb.shadow_size = SHADOW_SIZE if on else 0
	add_theme_stylebox_override("panel", sb)
