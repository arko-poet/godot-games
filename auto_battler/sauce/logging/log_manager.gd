class_name LogManager extends RefCounted

static var combat_log: RichTextLabel

const MESSAGES := {
	CombatAction.Type.BREAK: "%s breaks %s block.\n",
	CombatAction.Type.ATTACK: "%s hits for %s.\n",
	CombatAction.Type.HEAL: "%s heals for %s.\n",
	CombatAction.Type.BLOCK: "%s generates %s block.\n",
}


static func log_action(action: CombatAction) -> void:
	var message_arguments := [(action.source as Variant).display_name, action.value]
	var message: String = MESSAGES[action.type] % message_arguments
	combat_log.append_text("[color=red]%s[/color]" % message if action.source is Enemy else message)
