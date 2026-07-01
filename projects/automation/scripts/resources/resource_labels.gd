extends VBoxContainer


@onready var _coal_label: Label = %Coal


func _on_player_resources_coal_changed(coal: int) -> void:
	_coal_label.text = "Coal: %s" % coal
