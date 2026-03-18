class_name Card
extends PanelContainer

signal card_entered(card: Card)
signal card_exited(card: Card)

var _properties: Dictionary
var cost: int:
	set(value):
		cost = value
		cost_label.text = "%s" % value
var actions: Dictionary

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
