class_name HUD
extends CanvasLayer

@onready var level_label : Label = $LevelLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VolumeControl.value = AudioManager.global_volume


func _process(_delta) -> void:
	$BestLevelLabel.text = "Best Level: %s" % Globals.best_level


func _on_volume_control_drag_ended(_value_changed: bool) -> void:
	AudioManager.set_global_volume($VolumeControl.value)
	


func set_level(count: int) -> void:
	level_label.text = "Floor: %s" % count
	
