class_name CombatAction
extends RefCounted

enum Type {BREAK, ATTACK, HEAL, BLOCK}

var type: Type
var value: int
## reference to entity that created the action
var source: Object


func _init(p_type: Type, p_value: int, p_source: Object) -> void:
	type = p_type
	value = p_value
	source = p_source
