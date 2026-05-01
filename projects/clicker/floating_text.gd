extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position:y", 50, 1)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1)
	tween.finished.connect(queue_free)
