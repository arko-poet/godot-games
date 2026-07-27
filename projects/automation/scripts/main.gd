extends Node

const TARGET_AUTOMATRONS := 100

var automatrons_produced := 0:
	set(value):
		automatrons_produced = value
		automatrons_bar.value = automatrons_produced
		if automatrons_produced >= 100:
			get_tree().reload_current_scene()

@onready var automatrons_bar: ProgressBar = %AutomatronsBar


func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	SignalController.automatron_created.connect(_on_automatron_produced)
	automatrons_bar.max_value = TARGET_AUTOMATRONS


func _on_automatron_produced() -> void:
	automatrons_produced += 1
