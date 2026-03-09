extends PanelContainer

@onready var name_label: Label = $TextContainer/HBoxContainer/Name
@onready var description: Label = $TextContainer/Description

var upgrade: Upgrade


func set_upgrade(new_upgrade: Upgrade):
	upgrade = new_upgrade
	
	name_label.text = upgrade.name_
	if upgrade.property:
		description.text = "Increase %s by %s" % [upgrade.property, upgrade.value]
	else:
		description.text = "NEW WEAPON"
