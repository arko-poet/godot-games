extends Node

const PERK_BUTTON_SCENE := preload("res://perk_button.tscn")

@export var floating_text_scene: PackedScene

var time := 0.0
var cookies := 0
var click_cost := 10
var raise_income_cost := 10
var grandma_cost := 100
var grandma_count := 0
var properties: Dictionary[String, int] = {
	"grandma_cps": 10,
	"cookies_per_click": 1
}
var perk_buttons : Array[PerkButton] = []
var perk_data : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EndScene.hide()
	
	$UpgradeContainer/GrandmaButton.set_upgrade_name("Grandma")
	$UpgradeContainer/GrandmaButton.set_upgrade_cost(grandma_cost)
	
	$UpgradeContainer/ClickButton.set_upgrade_name("Click")
	$UpgradeContainer/ClickButton.set_upgrade_cost(click_cost)
	$UpgradeContainer/ClickButton.set_upgrade_count(properties["cookies_per_click"])
	
	perk_data = load("res://data/perks.json").get_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cookies >= 10000:
		$EndScene/Score.text = "Final Score: %s" % $VBoxContainer/Time.text
		$EndScene.show()
	else:
		$VBoxContainer/Time.text = _update_time(delta)
	
	if grandma_cost <= cookies:
		$UpgradeContainer/GrandmaButton.set_upgrade_color(Color(0, 1, 0, 1))
	else:
		$UpgradeContainer/GrandmaButton.set_upgrade_color(Color(1, 0, 0, 1))
	if click_cost <= cookies:
		$UpgradeContainer/ClickButton.set_upgrade_color(Color(0, 1, 0, 1))
	else:
		$UpgradeContainer/ClickButton.set_upgrade_color(Color(1, 0, 0, 1))
	
	for perk in perk_buttons:
		if cookies >= perk.cost:
			perk.modulate = Color (1, 1, 1)
			perk.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			perk.modulate = Color (0.5, 0.5, 0.5)
			perk.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
	var num_str := str(cookies)
	var result := ""
	var count := 0
	for i in range(num_str.length() - 1, -1, -1):
		result = num_str[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "," + result
	$VBoxContainer/Cookies.text = result
	$ProgressBar.value = cookies


func _update_time(delta: float) -> String:
	time += delta
	var hours = int(time / 3600)
	var minutes = int((time - hours * 3600) / 60)
	var seconds = time - hours * 3600 - minutes * 60
	return "%02d:%02d:%.1f" % [hours, minutes, seconds]


func _on_cookie_button_pressed() -> void:
	cookies += properties["cookies_per_click"]
	$CookieButton/CookieButtonPressed.play()
	var ft = floating_text_scene.instantiate()
	ft.text = "+%s" % properties["cookies_per_click"]
	ft.position = get_viewport().get_mouse_position()
	add_child(ft)


func _on_grandma_button_pressed() -> void:
	if grandma_cost <= cookies:
		cookies -= grandma_cost
		grandma_count += 1
		grandma_cost = int(1.5*pow(grandma_count, 2) + 13.5*grandma_count + 100)
		$UpgradeContainer/GrandmaButton.set_upgrade_cost(grandma_cost)
		$UpgradeContainer/GrandmaButton.set_upgrade_count(grandma_count)
	
	if grandma_count == 10:
		$AchievementManager.unlock_achievement("10 grandmas")
		
		_create_perk("grandma_0")

func _on_grandma_timer_timeout() -> void:
	cookies += grandma_count*properties["grandma_cps"]


func _on_click_button_pressed() -> void:
	if cookies >= click_cost:
		cookies -= click_cost
		properties["cookies_per_click"] += 1
		click_cost += 10
		$UpgradeContainer/ClickButton.set_upgrade_cost(click_cost)
		$UpgradeContainer/ClickButton.set_upgrade_count(properties["cookies_per_click"])
	
	if properties["cookies_per_click"] == 10:
		$AchievementManager.unlock_achievement("10 clicks")
		_create_perk("click_0")


func _create_perk(perk_id : String):
	var pd = perk_data[perk_id]
	var perk : PerkButton = PERK_BUTTON_SCENE.instantiate()
	perk.icon = load(pd["icon"])
	perk.tooltip_text = pd["name"]
	perk.cost = pd["cost"]
	perk.factor = pd["factor"]
	perk.operation = pd["operation"]
	if pd["target"]:
		perk.target = get_node(pd["target"])
	perk.property = pd["property"]
	
	perk_buttons.append(perk)
	$UpgradeContainer/PerkContainer.add_child(perk)
	perk.connect("purchase_perk", _purchase_perk)


func _purchase_perk(perk: PerkButton) -> void:
	cookies -= perk.cost
	if perk.target:
		
		var current_value = perk.target.get(perk.property)
		perk.target.set(perk.property, _perk_operation(perk, current_value))
	else:
		properties[perk.property] = _perk_operation(perk, properties[perk.property])
	perk_buttons.erase(perk)
	perk.queue_free()


func _perk_operation(perk: PerkButton, current_value):
	match perk.operation:
		"ADDER":
			return current_value + perk.factor
		"MULTIPLIER":
			return current_value * perk.factor


func _on_end_scene_play_again() -> void:
	get_tree().reload_current_scene()
	$EndScene.hide()
