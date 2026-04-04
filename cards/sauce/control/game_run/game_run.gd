## owns game properties that persist across encounters
## also responsible for managing flow between ui scenes
class_name GameRun
extends Control

signal player_died
signal encounter_finished

const CardScene := preload("res://sauce/control/card/card.tscn")

const MAX_MANA := 3
const STARTING_HAND_SIZE := 5
const CARD_CHOICE_SIZE := 3
const STARTING_MAX_HP := 100

var max_hp: int:
	set(value):
		max_hp = value
		_update_hp_label()
var card_data: Dictionary
var hp: int:
	set(value):
		hp = max(0, min(value, max_hp))
		_update_hp_label()
		if hp == 0:
			player_died.emit()
var encounter_num := 0:
	set(value):
		encounter_num = value
		encounter_label.text = "Encounter: %s" % encounter_num

@onready var hp_label: Label = $HBoxContainer/HPLabel
@onready var debug: VBoxContainer = $Debug
@onready var card_choice: CardChoice = $CardChoice
@onready var combat_encounter: CombatEncounter = $CombatEncounter
@onready var deck_label: Button = $DeckLabel
@onready var deck: Deck = $Deck
@onready var encounter_label: Label = $HBoxContainer/EncounterLabel
@onready var next_button: Button = $NextButton
@onready var relic_manager: RelicManager = $RelicManager
@onready var rewards_panel: RewardsPanel = $RewardsPanel
@onready var curtain: ColorRect = $Curtain
@onready var dimmer: ColorRect = $Dimmer


func _ready() -> void:
	max_hp = STARTING_MAX_HP
	hp = max_hp
	card_data = load("res://sauce/control/card/cards.json").data
	combat_encounter.game_run = self
	_starter_deck()

	debug.game_run = self


func combat_finished() -> void:
	combat_encounter.hide()
	_get_rewards()


func execute_monster_actions(actions: Array[Action]) -> void:
	for action in actions:
		if action.type == Action.Type.ATTACK:
			combat_encounter.hit_player(action.value)
	combat_encounter.start_turn()
			
			
func next_encounter(monster: Monster) -> void:
	combat_encounter.new_encounter(monster)
	encounter_num += 1
			
			
func turn_dimmer(on: bool) -> void:
	dimmer.visible = on
			
			
func _get_rewards() -> void:
	turn_dimmer(true)
	rewards_panel.new_rewards(relic_manager.get_new_relic())
	rewards_panel.show()


func _starter_deck() -> void:
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.default_properties = card_data["Bozo Attack"]
		_add_card(card)
	
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.default_properties = card_data["Bozo Block"]
		_add_card(card)


func _on_card_choice_card_chosen(card: Card) -> void:
	if card:
		_add_card(card)
		
	card_choice.hide()
	rewards_panel.show()
	rewards_panel.card_chosen()


func _choose_cards() -> void:
	var card_keys = card_data.keys()
	card_keys.shuffle()
	var cards: Array[Card] = []
	for i in range(CARD_CHOICE_SIZE):
		var card: Card = CardScene.instantiate()
		card.default_properties = card_data[card_keys[i]]
		cards.append(card)
	card_choice.new_card_choice(cards)
	card_choice.show()


func _add_card(card: Card) -> void:
	deck.add_card(card)
	_update_deck_label()


func _update_deck_label() -> void:
	deck_label.text = "DECK: %s" % deck.card_container.get_children().size()
	

func _on_deck_label_pressed() -> void:
	if deck.visible:
		deck.hide()
		turn_dimmer(false)
	else:
		deck.show()
		turn_dimmer(true)


func _update_hp_label() -> void:
	hp_label.text = "%s/%s" % [hp, max_hp]


func _on_next_button_pressed() -> void:
	curtain.show()
	
	var t := create_tween()
	t.tween_property(curtain, ^"modulate:a", 1.0, 0.8)
	await t.finished
	encounter_finished.emit()
	
	t = create_tween()
	t.tween_interval(0.4)
	t.tween_property(curtain, ^"modulate:a", 0.0, 0.8)
	t.finished.connect(curtain.hide)
	next_button.hide()


func _on_rewards_rewards_claimed() -> void:
	rewards_panel.hide()
	turn_dimmer(false)
	next_button.show()


func _on_rewards_card_choice_requested() -> void:
	rewards_panel.hide()
	_choose_cards()


func _on_rewards_relic_claimed(relic: Relic) -> void:
	relic_manager.add_relic(relic)
