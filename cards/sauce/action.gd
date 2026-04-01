class_name Action
extends RefCounted

enum ActionType {ATTACK, BLOCK, DRAW, HEAL, STRENGTH, MAX_HP, MANA, COST}

const STRING_TO_ACTION := {
	"attack": ActionType.ATTACK,
	"block": ActionType.BLOCK,
	"draw": ActionType.DRAW,
	"heal": ActionType.HEAL,
	"strength": ActionType.STRENGTH,
	"max_hp": ActionType.MAX_HP,
	"mana": ActionType.MANA,
	"cost": ActionType.COST
}

var type: ActionType
var value: int
var repeats: int = 1


func _init(action: Dictionary = {}) -> void:
	if action != {}:
		type = STRING_TO_ACTION.get(action["type"])
		value = action.get("value")
		repeats = action.get("repeats", 1)
