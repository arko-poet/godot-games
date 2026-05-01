extends Node

var best_level := 0
var best_combo := 0

func _ready() -> void:
	_load_scores()

func record_level(level: int) -> void:
	if level > best_level:
		best_level = level
		_save_data()

func record_combo(combo : int) -> void:
	if combo > best_combo:
		best_combo = combo
		_save_data()

func _save_data() -> void:
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("best_scores", "best_level", best_level)
	config.set_value("best_scores", "best_combo", best_combo)
	
	config.save("user://scores.cfg")

func _load_scores() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://scores.cfg")
	# If the file didn't load, ignore it.
	if err != OK:
		return

	best_level = config.get_value("best_scores", "best_level")
	best_combo = config.get_value("best_scores", "best_combo")
	
