class_name Card
extends Control

signal card_entered(card: Card)
signal card_exited(card: Card)

const SHADOW_SIZE := 12

var properties: Dictionary ## default card properties, before any modifications
var cost: int:
	set(value):
		cost = max(0, value)
		cost_label.text = "%s" % cost
var actions: Array[Action] = []
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
	
	for action in properties["actions"]:
		actions.append(Action.new(action))
	
	_set_description()


func set_to_default_properties() -> void:
	cost = int(properties["cost"])


func _set_description() -> void:
	var description := ""
	for action in actions:
		var val = action.value
		match action.type:
			Action.ActionType.ATTACK:
				if action.repeats == 1:
					description += "Deals %s damage. " % action.value
				else:
					description += "Deals %s damage %s times. " % [val, action.repeats]
			Action.ActionType.BLOCK:
				description += "Adds %s block. " % val
			Action.ActionType.DRAW:
				description += "Draw %s cards. " % val
			Action.ActionType.HEAL:
				description += "Heals for %s. " % val
			Action.ActionType.STRENGTH:
				description += "Increase strength by %s. " % val
			Action.ActionType.MAX_HP:
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
