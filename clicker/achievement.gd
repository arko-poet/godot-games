extends Control


func _ready():
	var tween := create_tween()
	tween.tween_property(self, "position:y", 0, 1)
	tween.tween_property(self, "position:y", -65, 1).set_delay(1)
	tween.finished.connect(queue_free)


func set_achievement_properties(achievement_name: String, achievement_resource: String) -> void:
	$HBoxContainer/TextureRect.texture = load(achievement_resource)
	$HBoxContainer/VBoxContainer/AchievementName.text = achievement_name
