class_name LogManager
extends RefCounted


static var combat_log: RichTextLabel


static func log_action() -> void:
	combat_log.append_text("ABOBA\n")
