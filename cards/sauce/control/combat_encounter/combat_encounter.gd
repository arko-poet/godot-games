## everything needed for processing combat
class_name CombatEncounter
extends Control

signal monster_attacked(damage: int)
signal turn_started
signal card_played
signal turn_ended

var game_run: GameRun
var mana: int:
	set(value):
		mana = value
		mana_label.text = "%s/%s" % [mana, game_run.MAX_MANA]
		_update_card_playability()
var draw_pile: Array[Card] = []
var discard_pile: Array[Card] = []
var block: int:
	set(value):
		block = value
		block_label.text = "BLOCK: %s" % value
var strength: int:
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


## initialise new encounter by resetting to base state
func new_encounter(spawn_monster: Monster) -> void:
	monster = spawn_monster
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
		card.playable = mana >= card.cost
		hand.add_card(card)
	else:
		_shuffle_discard_pile()
		if not draw_pile.is_empty():
			draw_card()

	_update_pile_labels()


func hit_player(damage: int) -> void:
	var damage_left = max(0, damage - block)
	block = max(0, block - damage)
	game_run.hp -= damage_left


func _shuffle_discard_pile() -> void:
	for i in discard_pile.size():
		var card: Card = discard_pile.pop_front()
		draw_pile.append(card)
	draw_pile.shuffle()


func _on_hand_card_played(card: Card) -> void:
	mana -= card.cost
	_execute_actions(game_run.relic_manager.process_actions(card.actions))
	_discard_card(card)
	hand.set_to_default_card_properties()
	card_played.emit()


func _discard_card(card: Card) -> void:
	discard_pile.append(card)
	_update_pile_labels()


## called after actions have been processed by relic manager
func _execute_actions(actions: Array[Action]) -> void:
	for action in actions:
		var val = action.value
		match action.type:
			Action.Type.ATTACK:
				for i in range(action.repeats):
					_attack(val)
			Action.Type.BLOCK:
				block += val
			Action.Type.DRAW:
				for i in range(val):
					draw_card()
			Action.Type.HEAL:
				game_run.hp += val
			Action.Type.STRENGTH:
				strength += val
			Action.Type.MAX_HP:
				game_run.max_hp += val
			Action.Type.MANA:
				mana += val
			Action.Type.COST:
				hand.reduce_card_costs(val)
			_:
				push_error("unknown action type: %s" % action)


func _attack(damage: int):
	monster_attacked.emit(damage + strength)


func _on_hand_card_rejected(card: Card) -> void:
	_discard_card(card)


func _update_pile_labels() -> void:
	draw_pile_label.text = "draw pile: %s" % draw_pile.size()
	discard_pile_label.text = "discard pile: %s" % discard_pile.size()


func _on_end_turn_button_pressed() -> void:
	turn_ended.emit()
	
	monster.monster_turn()
	for c in hand.clear():
		discard_pile.append(c)
	for i in range(game_run.STARTING_HAND_SIZE):
		draw_card()
	mana = game_run.MAX_MANA
	block = 0
	
	turn_started.emit()


func _on_relic_manager_relic_actions_created(actions: Array[Action]) -> void:
	_execute_actions(actions)


func _on_hand_cost_changed() -> void:
	_update_card_playability()


func _update_card_playability() -> void:
	for card: Card in hand.get_children():
		card.playable = mana >= card.cost
