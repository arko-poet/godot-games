class_name CombatEncounter
extends Control

signal monster_attacked(damage: int)

var game_run: GameRun
var mana: int:
	set(value):
		mana = value
		mana_label.text = "%s/%s" % [mana, game_run.MAX_MANA]
		_mana_changed()
var draw_pile: Array[Card] = []
var discard_pile: Array[Card] = []
var block: int:
	set(value):
		block = value
		block_label.text = "BLOCK: %s" % value
var strength: int: # TODO update cards in hand to account for strength
	set(value):
		strength = value
		strength_label.text = "STRENGTH: %s" % value
var monster: Monster

@onready var hand: Hand = $Hand
@onready var mana_label: Label = $PlayerStatsBox/ManaLabel
@onready var draw_pile_label: Label = $PlayerStatsBox/DrawPileLabel
@onready var discard_pile_label: Label = $PlayerStatsBox/DiscardPileLabel
@onready var end_turn_button: Button = $EndTurnButton
@onready var block_label: Label = $PlayerStatsBox/BlockLabel
@onready var strength_label: Label = $PlayerStatsBox/StrengthLabel
@onready var dimmer: ColorRect = $Dimmer


func new_encounter(new_monster: Monster) -> void:
	monster = new_monster
	mana = game_run.MAX_MANA
	strength = 0
	block = 0

	hand.clear()
	discard_pile.clear()
	draw_pile = game_run.deck.get_card_copies()
	draw_pile.shuffle()
	for i in range(game_run.STARTING_HAND_SIZE):
		draw_card()
	
	show()


func draw_card() -> void:
	if not draw_pile.is_empty():
		var card: Card = draw_pile.pop_at(0)
		hand.add_card(card)
		card.playable = mana >= card.cost
	else:
		_shuffle_discard_pile()
		if not draw_pile.is_empty():
			draw_card()

	_update_pile_labels()


func _shuffle_discard_pile() -> void:
	for i in discard_pile.size():
		var card: Card = discard_pile.pop_front()
		draw_pile.append(card)
	draw_pile.shuffle()
	assert(discard_pile.is_empty())


func _on_hand_card_played(card: Card) -> void:
	assert(mana >= card.cost)
	assert(card.actions != [])
	mana -= card.cost
	_execute_card_actions(card)
	_discard_card(card)


func _discard_card(card: Card) -> void:
	discard_pile.append(card)
	_update_pile_labels()


func _execute_card_actions(card: Card) -> void:
	var actions := card.actions
	for action in actions:
		var val = action.value
		match action.type:
			Action.ActionType.ATTACK:
				for i in range(action.repeats):
					_attack(val)
			Action.ActionType.BLOCK:
				block += val
			Action.ActionType.DRAW:
				for i in range(val):
					draw_card()
			Action.ActionType.HEAL:
				game_run.hp += val
			Action.ActionType.STRENGTH:
				strength += val
			Action.ActionType.MAX_HP:
				game_run.max_hp += val
			_:
				push_error("unknown action type: %s" % action)


func _attack(damage: int):
	emit_signal("monster_attacked", damage + strength)


func _on_hand_card_rejected(card: Card) -> void:
	_discard_card(card)


func _update_pile_labels() -> void:
	draw_pile_label.text = "draw pile: %s" % draw_pile.size()
	discard_pile_label.text = "discard pile: %s" % discard_pile.size()


func _mana_changed() -> void:
	for card: Card in hand.get_children():
		card.playable = mana >= card.cost


func _on_end_turn_button_pressed() -> void:
	monster.monster_turn()
	for c in hand.clear():
		discard_pile.append(c)
	for i in range(game_run.STARTING_HAND_SIZE):
		draw_card()
	mana = game_run.MAX_MANA
	block = 0


func turn_dimmer(on: bool) -> void:
	dimmer.visible = on


func hit_player(damage: int) -> void:
	print("hit")
	var damage_left = max(0, damage - block)
	block = max(0, block - damage)
	game_run.hp -= damage_left
