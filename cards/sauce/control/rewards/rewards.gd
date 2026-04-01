class_name RewardsPanel
extends Control

signal rewards_claimed
signal relic_claimed(relic: Relic)
signal card_choice_requested

var relic: Relic

@onready var card_choice: Button = $Panel/RewardChoices/CardChoice
@onready var relic_choice: Button = $Panel/RewardChoices/RelicChoice
@onready var reward_choices: VBoxContainer = $Panel/RewardChoices


func new_rewards(new_relic: Relic) -> void:
	if new_relic:
		relic = new_relic
		relic_choice.add_theme_color_override("icon_normal_color", relic.modulate)
		relic_choice.add_theme_color_override("icon_hover_color", relic.modulate)
		relic_choice.add_theme_color_override("icon_pressed_color", relic.modulate)
	if reward_choices.get_child_count() == 1:
		reward_choices.add_child(card_choice)
		if relic:
			reward_choices.add_child(relic_choice)


func card_chosen() -> void:
	_reward_claimed()


func _on_card_choice_pressed() -> void:
	card_choice_requested.emit()
	reward_choices.remove_child(card_choice)


func _on_relic_choice_pressed() -> void:
	emit_signal("relic_claimed", relic)
	relic = null
	reward_choices.remove_child(relic_choice)
	_reward_claimed()


func _reward_claimed() -> void:
	if reward_choices.get_child_count() == 1:
		rewards_claimed.emit()
