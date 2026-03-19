class_name Card
extends PanelContainer

signal card_entered(card: Card)
signal card_exited(card: Card)

const SHADOW_SIZE := 8

var _properties: Dictionary
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
	name_label.text = _properties["name"]
	cost = int(_properties["cost"])
	var description := ""
	actions = _properties["actions"]
	for action in actions:
		match action:
			"attack":
				description += ("Deals %s damage. " % int(actions[action]["value"]))
			_:
				push_error("unrecognised action name: %s" % action)
	description_label.text = description


func set_card_properties(properties: Dictionary) -> void:
	_properties = properties


func _on_mouse_entered() -> void:
	emit_signal("card_entered", self)


func _on_mouse_exited() -> void:
	emit_signal("card_exited", self)


func _switch_shadow(on: bool) -> void:
	var sb : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	sb.shadow_size = 12 if on else 0
	add_theme_stylebox_override("panel", sb)
