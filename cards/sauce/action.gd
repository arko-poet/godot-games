class_name Action
extends RefCounted

enum ActionType {ATTACK, BLOCK, DRAW, HEAL, STRENGTH, MAX_HP}

const STRING_TO_ACTION := {
	"attack": ActionType.ATTACK,
	"block": ActionType.BLOCK,
	"draw": ActionType.DRAW,
	"heal": ActionType.HEAL,
	"strength": ActionType.STRENGTH,
	"max_hp": ActionType.MAX_HP
}

var type: ActionType
var value: int
var repeats: int


func _init(action: Dictionary) -> void:
	type = STRING_TO_ACTION.get(action["type"], ActionType.ATTACK)
	value = action.get("value", 0)
	repeats = action.get("repeats", 1)
