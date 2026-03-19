extends Control

signal card_chosen(card: Card)

const CARD_HOVER_SCALE := Vector2(1.2, 1.2)

var selected_card: Card

@onready var card_container: HBoxContainer = $CardContainer
@onready var skip_button: Button = $SkipButton


func _ready() -> void:
	# TODO after implementing card choosing
	var card_scene: PackedScene = load("res://sauce/control/card/card.tscn")
	var cards: Array[Card] = []
	for i in range(3):
		var card: Card = card_scene.instantiate()
		cards.append(card)
	new_card_choice(cards)



func new_card_choice(cards: Array[Card]) -> void:
	for child in card_container.get_children():
		child.queue_free()
	for card in cards:
		card.card_entered.connect(_on_card_entered)
		card.card_exited.connect(_on_card_exited)
		card_container.add_child(card)


func _on_skip_button_pressed() -> void:
	emit_signal("card_chosen", null)
	
	
func _on_card_entered(card: Card) -> void:
	card.scale = CARD_HOVER_SCALE
	selected_card = card


func _on_card_exited(card: Card) -> void:
	card.scale = Vector2.ONE
	selected_card = null


func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed and selected_card:
		emit_signal("card_chosen", selected_card)
		# TODO it may be necessary to clear selected card here
