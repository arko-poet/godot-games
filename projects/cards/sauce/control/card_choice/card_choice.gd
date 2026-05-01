class_name CardChoice
extends Control

signal card_chosen(card: Card)

const DEFAULT_CARD_SCALE := Vector2(0.8, 0.8)

var selected_card: Card

@onready var card_container: HBoxContainer = $CardContainer
@onready var skip_button: Button = $SkipButton


func new_card_choice(cards: Array[Card]) -> void:
	for card in cards:
		card.card_entered.connect(_on_card_entered)
		card.card_exited.connect(_on_card_exited)
		
		card_container.add_child(card)


func _on_skip_button_pressed() -> void:
	card_chosen.emit(null)
	_clear()
	
	
func _on_card_entered(card: Card) -> void:
	card.scale = Vector2.ONE
	selected_card = card


func _on_card_exited(card: Card) -> void:
	card.scale = DEFAULT_CARD_SCALE
	selected_card = null


func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed and selected_card:
		var chosen_card = selected_card
		selected_card.disconnect("card_entered", _on_card_entered)
		selected_card.disconnect("card_exited", _on_card_exited)
		card_container.remove_child(selected_card)
		card_chosen.emit(chosen_card)
		_clear()
		

func _clear() -> void:
	selected_card = null
	for child in card_container.get_children():
		child.queue_free()
