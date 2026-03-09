extends PanelContainer

@onready var name_label: Label = $TextContainer/HBoxContainer/Name

var upgrade: Upgrade


func set_upgrade(new_upgrade: Upgrade):
	upgrade = new_upgrade
	name_label.text = upgrade.name_
