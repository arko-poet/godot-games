class_name UI
extends Control

const CardScene := preload("res://sauce/control/card/card.tscn")

const MAX_HP := 100
const MAX_MANA := 3
const STARTING_HAND_SIZE := 5

var card_data: Dictionary
var hp: int:
	set(value):
		hp = value
		hp_label.text = "%s/%s" % [hp, MAX_HP]
var mana: int:
	set(value):
		mana = value
		mana_label.text = "%s/%s" % [mana, MAX_MANA]
		_mana_changed()
var deck: Array[Card] = []
var draw_pile: Array[Card] = []
var discard_pile: Array[Card] = []
var monster_max_hp := 100
var monster_hp := 100:
	set(value):
		monster_hp = max(value, 0)
		monster_hp_label.text = "%s/%s" % [monster_hp, monster_max_hp]

@onready var hand: Hand = $Hand
@onready var hp_label: Label = $PlayerStatsBox/HPLabel
@onready var mana_label: Label = $PlayerStatsBox/ManaLabel
@onready var debug: VBoxContainer = $Debug
@onready var draw_pile_label: Label = $PlayerStatsBox/DrawPileLabel
@onready var discard_pile_label: Label = $PlayerStatsBox/DiscardPileLabel
@onready var monster_hp_label: Label = $PlayerStatsBox/MonsterHPLabel
@onready var end_turn_button: Button = $EndTurnButton


func _ready() -> void:
	hp = MAX_HP
	mana = MAX_MANA
	card_data = load("res://sauce/control/card/cards.json").get_data()
	_starter_deck()
	_start_combat()
	
	debug.ui = self


func _starter_deck() -> void:
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.set_card_properties(card_data["Bozo Attack"])
		deck.append(card)
	
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.set_card_properties(card_data["Bozo Block"])
		deck.append(card)


func _start_combat() -> void:
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
	for i in range(STARTING_HAND_SIZE):
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
	
	print("_draw_card()")
	print(draw_pile)
	print(discard_pile)
	print("------------")
		

func _shuffle_discard_pile() -> void:
	for i in discard_pile.size():
		var card: Card = discard_pile.pop_front()
		draw_pile.append(card)
	draw_pile.shuffle()
	assert(discard_pile.is_empty())


func _on_hand_card_played(card: Card) -> void:
	assert(mana >= card.cost)
	mana -= card.cost
	_execute_card_actions(card)
	_discard_card(card)


func _discard_card(card: Card) -> void:
	discard_pile.append(card)
	print(discard_pile)
	_update_pile_labels()
	

func _execute_card_actions(card: Card) -> void:
	var actions = card.actions
	for action in actions:
		match action:
			"attack":
				_attack(int(actions[action]["value"]))
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
	draw_card()
	mana = MAX_MANA


func _monster_turn() -> void:
	var monster_damage = 10
	hp -= monster_damage
