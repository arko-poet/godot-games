class_name CombatEncounter
extends Control

var game_run: GameRun
var mana: int:
	set(value):
		mana = value
		mana_label.text = "%s/%s" % [mana, game_run.MAX_MANA]
		_mana_changed()
var draw_pile: Array[Card] = []
var discard_pile: Array[Card] = []
var monster_max_hp := 100
var monster_hp := 100:
	set(value):
		monster_hp = max(value, 0)
		monster_hp_label.text = "%s/%s" % [monster_hp, monster_max_hp]
		if monster_hp == 0:
			game_run.combat_finished()
var block := 0:
	set(value):
		block = value
		block_label.text = "BLOCK: %s" % value

@onready var hand: Hand = $Hand
@onready var mana_label: Label = $PlayerStatsBox/ManaLabel
@onready var draw_pile_label: Label = $PlayerStatsBox/DrawPileLabel
@onready var discard_pile_label: Label = $PlayerStatsBox/DiscardPileLabel
@onready var monster_hp_label: Label = $PlayerStatsBox/MonsterHPLabel
@onready var end_turn_button: Button = $EndTurnButton
@onready var block_label: Label = $PlayerStatsBox/BlockLabel


func _ready() -> void:
	mana = game_run.MAX_MANA


func new_encounter(hp: int) -> void:
	monster_max_hp = hp
	monster_hp = hp

	mana = game_run.MAX_MANA

	hand.clear()
	discard_pile.clear()
	draw_pile = game_run.deck.get_card_copies()
	draw_pile.shuffle()
	for i in range(game_run.STARTING_HAND_SIZE):
		draw_card()


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
	assert(card.actions != {})
	mana -= card.cost
	_execute_card_actions(card)
	_discard_card(card)


func _discard_card(card: Card) -> void:
	discard_pile.append(card)
	_update_pile_labels()


func _execute_card_actions(card: Card) -> void:
	var actions = card.actions
	for action in actions:
		match action:
			"attack":
				_attack(int(actions[action]["value"]))
			"block":
				block += int(actions[action]["value"])
			"draw":
				for i in range(int(actions[action]["value"])):
					draw_card()
			"heal":
				game_run.hp += int(actions[action]["value"])
			_:
				push_error("unknown action type: %s" % action)


func _attack(damage: int):
	monster_hp -= damage


func _on_hand_card_rejected(card: Card) -> void:
	_discard_card(card)


func _update_pile_labels() -> void:
	draw_pile_label.text = "draw pile: %s" % draw_pile.size()
	discard_pile_label.text = "discard pile: %s" % discard_pile.size()


func _mana_changed() -> void:
	for card: Card in hand.get_children():
		card.playable = mana >= card.cost


func _on_end_turn_button_pressed() -> void:
	_monster_turn()
	for c in hand.clear():
		discard_pile.append(c)
	for i in range(game_run.STARTING_HAND_SIZE):
		draw_card()
	mana = game_run.MAX_MANA
	block = 0


func _monster_turn() -> void:
	var monster_damage = 10
	var damage_left = max(0, monster_damage - block)
	block = max(0, block - monster_damage)
	game_run.hp -= damage_left
