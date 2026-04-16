class_name LogManager
extends RefCounted

static var combat_log: RichTextLabel


static func log_action(action: Dictionary) -> void:
	var producer: String = action["producer"].display_name
	var message: String
	var enemy_action := true if producer == "Enemy" else false
	var value: int
	if "block_damage" in action:
		value = action["block_damage"]
		message = ("%s breaks %s block.\n" % [producer, value])
		_log_message(message, enemy_action)
	
	if "attack_damage" in action:
		value = action["attack_damage"]
		message = ("%s hits for %s.\n" % [producer, value])
		_log_message(message, enemy_action)
	
	if "heal" in action:
		value = action["heal_damage"]
		message = ("%s heals for %s.\n" % [producer, value])
		_log_message(message, enemy_action)
	
	if "block" in action:
		value = action["block"]
		message = ("%s generates %s block.\n" % [producer, value])
		_log_message(message, enemy_action)

	
static func _log_message(message: String, enemy_action: bool):
	combat_log.append_text("[color=red]%s[/color]" % message if enemy_action else message)
