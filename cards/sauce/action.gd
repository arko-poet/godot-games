class_name Action
extends RefCounted

## Type is used so that action executor and relic manager knows how to process action
enum Type {ATTACK, BLOCK, DRAW, HEAL, STRENGTH, MAX_HP, MANA, COST}

const STRING_TO_ACTION := {
	"attack": Type.ATTACK,
	"block": Type.BLOCK,
	"draw": Type.DRAW,
	"heal": Type.HEAL,
	"strength": Type.STRENGTH,
	"max_hp": Type.MAX_HP,
	"mana": Type.MANA,
	"cost": Type.COST
}

var type: Type
var value: int:
	set(new_val):
		value = max(0, new_val)
var repeats: int = 1
var monster_action := false ## otherwise player action is assumed


## optionally initialize with dictionary, otherwise set properties manually after initialization
func _init(action: Dictionary = {}) -> void:
	if action != {}:
		type = STRING_TO_ACTION.get(action["type"])
		value = action.get("value")
		repeats = action.get("repeats", 1)
