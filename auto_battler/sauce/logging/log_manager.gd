class_name LogManager extends RefCounted

static var combat_log: RichTextLabel


static func log_action(action: CombatAction) -> void:
	var message_arguments := [action.source.display_name, action.value]
	var message: String
	match action.type:
		CombatAction.Type.BREAK:
			message = ("%s breaks %s block.\n" % message_arguments)
		CombatAction.Type.ATTACK:
			message = ("%s hits for %s.\n" % message_arguments)
		CombatAction.Type.HEAL:
			message = ("%s heals for %s.\n" % message_arguments)
		CombatAction.Type.BLOCK:
			message = ("%s generates %s block.\n" % message_arguments)
		_:
			push_error("Unknown CombatAction.Type")
	combat_log.append_text("[color=red]%s[/color]" % message if action.source is Enemy else message)
