extends Control

signal upgrade_chosen(upgrade: int)

var selected_card := 1
@onready var cards := {
	1: $MainPanel/UpgradeCards/Card1,
	2: $MainPanel/UpgradeCards/Card2,
	3: $MainPanel/UpgradeCards/Card3
}
@onready var arrow: TextureRect = $Arrow



func _ready() -> void:
	await get_tree().process_frame
	_set_arrow_position()


func _set_arrow_position() -> void:
	var card : PanelContainer = cards[selected_card]
	if not card:
		push_error("invalid slected_card index: %s" % selected_card)
		return
	arrow.global_position.y = card.global_position.y + 0.5 * (card.size.y - arrow.size.y)


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_up"):
		selected_card = (selected_card + 1) % 3 + 1
		_set_arrow_position()
	elif event.is_action_pressed("ui_down"):
		selected_card = 1 + selected_card % 3
		_set_arrow_position()
	elif event.is_action_pressed("ui_accept"):
		emit_signal("upgrade_chosen", selected_card)
