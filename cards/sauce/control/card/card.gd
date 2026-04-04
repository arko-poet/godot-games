class_name Card
extends Control

signal card_entered(card: Card)
signal card_exited(card: Card)

const SHADOW_SIZE := 12

var default_properties: Dictionary ## used for initialization and resetting to defaults
var cost: int:
	set(value):
		cost = max(0, value)
		cost_label.text = "%s" % cost
var actions: Array[Action] = []
var playable := false:
	set(value):
		playable = value
		_switch_shadow(value)
var transform_tween: Tween

@onready var cost_label: Label = $CostLabel
@onready var name_label: Label = $NameLabel
@onready var description_label: RichTextLabel = $DescriptionLabel


func _ready() -> void:
	if not default_properties:
		return
	name_label.text = default_properties["name"]
	cost = int(default_properties["cost"])
	
	for action in default_properties["actions"]:
		actions.append(Action.new(action))
	
	_set_description()


func set_to_default_properties() -> void:
	cost = int(default_properties["cost"])


func _set_description() -> void:
	var description := ""
	for action in actions:
		var val = action.value
		match action.type:
			Action.Type.ATTACK:
				if action.repeats == 1:
					description += "Deals %s damage. " % action.value
				else:
					description += "Deals %s damage %s times. " % [val, action.repeats]
			Action.Type.BLOCK:
				description += "Adds %s block. " % val
			Action.Type.DRAW:
				description += "Draw %s cards. " % val
			Action.Type.HEAL:
				description += "Heals for %s. " % val
			Action.Type.STRENGTH:
				description += "Increase strength by %s. " % val
			Action.Type.MAX_HP:
				description += "Increase max hp by %s." % val
			_:
				push_error("unrecognised action name: %s" % action)
	description_label.text = KeywordService.parse_text(description)


func _on_mouse_entered() -> void:
	print("entered")
	card_entered.emit(self)


func _on_mouse_exited() -> void:
	print("why")
	#print(get_global_rect())
	#if not get_global_rect().has_point(get_global_mouse_position()):
		#print("exit")
	card_exited.emit(self)


func _switch_shadow(on: bool) -> void:
	var sb: StyleBoxFlat = get_theme_stylebox(&"panel").duplicate()
	sb.shadow_size = SHADOW_SIZE if on else 0
	add_theme_stylebox_override(&"panel", sb)


func _on_description_label_meta_hover_started(meta: Variant) -> void:
	description_label.tooltip_text = KeywordService.get_description(meta)


func _on_description_label_meta_hover_ended(_meta: Variant) -> void:
	description_label.tooltip_text = ""
