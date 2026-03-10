extends PanelContainer

const RARITY_COLORS := {
	UpgradeService.Rarity.COMMON: Color("C8CDD8"),
	UpgradeService.Rarity.RARE: Color("3A8DFF"),
	UpgradeService.Rarity.EPIC: Color("A335EE"),
	UpgradeService.Rarity.LEGENDARY: Color("FF9F1C")
}
const RARITY_NAMES := {
	UpgradeService.Rarity.COMMON: "COMMON",
	UpgradeService.Rarity.RARE: "RARE",
	UpgradeService.Rarity.EPIC: "EPIC",
	UpgradeService.Rarity.LEGENDARY: "LEGENDARY"
}
const ICON_PATHS := {
	UpgradeService.WeaponID.BALLS: preload("res://assets/balls_icon.png"),
	UpgradeService.WeaponID.SWORD: preload("res://assets/swords/Iicon_32_01.png"),
	UpgradeService.WeaponID.CHAKRAMS: preload("res://assets/chakram_icon.png"),
	UpgradeService.WeaponID.SPEARS: preload("res://assets/spear.png"),
	UpgradeService.WeaponID.BOUNCERS: preload("res://assets/bouncer_icon.png"),
	UpgradeService.WeaponID.FIRE_STAFF: preload("res://assets/fire_staff_icon.png"),
	UpgradeService.WeaponID.TOXIC_VIALS: preload("res://assets/pixel-art-potion-pack-V1.1/sprites/green/potion_green_medium.png")
}

var upgrade: Upgrade

@onready var name_label: Label = $TextContainer/HBoxContainer/Name
@onready var description: Label = $TextContainer/Description
@onready var rarity_label: Label = $TextContainer/HBoxContainer/Rarity
@onready var icon: TextureRect = $TextContainer/HBoxContainer/Icon


func set_upgrade(new_upgrade: Upgrade):
	upgrade = new_upgrade
	
	name_label.text = upgrade.name_
	if upgrade.property:
		description.text = "Increase %s by %s" % [upgrade.property, upgrade.value]
	else:
		description.text = "NEW WEAPON"
	
	var rarity_color : Color = RARITY_COLORS[upgrade.rarity]
	rarity_label.add_theme_color_override("font_color", rarity_color)
	rarity_label.text = "[%s]" % RARITY_NAMES[upgrade.rarity]
	
	var stylebox := get_theme_stylebox("panel").duplicate()
	stylebox.border_color = rarity_color
	add_theme_stylebox_override("panel", stylebox)
	
	icon.texture = ICON_PATHS[upgrade.id]
