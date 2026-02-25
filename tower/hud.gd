class_name HUD
extends CanvasLayer

@onready var level_label : Label = $CurrentRunLabels/LevelLabel
@onready var best_level_label : Label = $BestLevelLabel
@onready var time_left_label : Label = $CurrentRunLabels/TimeLeftLabel
@onready var volume_control_slider : HSlider = $VolumeControlSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_control_slider.value = AudioManager.global_volume


func _process(_delta) -> void:
	best_level_label.text = "Best Level: %s" % Globals.best_level


func _on_volume_control_drag_ended(_value_changed: bool) -> void:
	AudioManager.set_global_volume(volume_control_slider.value)
	

func update_level(count: int) -> void:
	level_label.text = "Floor: %s" % count
	
	
func update_time_left(t: float) -> void:
	time_left_label.text = "Speed Up In: %.1f" % t
