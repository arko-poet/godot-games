extends Node2D

var damage: int

@onready var label: Label = $Label


func _ready() -> void:
	label.text = "%s" % damage
	var tween := create_tween()
	
	

	tween.set_parallel()

	var original_scale := label.scale
	label.scale = original_scale * 0.6
	var new_scale := original_scale * 1.15

	var drift_x = randf_range(-12.0, 12.0)
	var drift_y = randf_range(-32.0, -24.0)
	tween.tween_property(label, "scale", new_scale, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", original_scale, 0.10).set_delay(0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position", Vector2(drift_x, drift_y), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 1)
	tween.finished.connect(queue_free)


#func _process(_delta) -> void:
	#print("-")
	#print("N2D global_position = %s" % global_position)
	#print("N2D position = %s" % position)
	#print("Label global_position = %s" % global_position)
	#print("Label position = %s" % position)
