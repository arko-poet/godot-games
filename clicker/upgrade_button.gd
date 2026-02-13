extends Button

func set_upgrade_name(n: String) -> void:
	$UpgradeName.text = n


func set_upgrade_cost(cost: int) -> void:
	$UpgradeCost.text = "$%s" % cost


func set_upgrade_color(color: Color) -> void:
	$UpgradeCost.add_theme_color_override("font_color", color)


func set_upgrade_count(c: int) -> void:
	$UpgradeCount.text = str(c)
