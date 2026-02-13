extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bitmap = BitMap.new()
	var image = texture_normal.get_image()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
	
	
func _on_mouse_entered() -> void:
	_animate_cookie(Vector2(0.11, 0.11))


func _on_mouse_exited() -> void:
	_animate_cookie(Vector2(0.1, 0.1))


func _on_button_down() -> void:
	_animate_cookie(Vector2(0.09, 0.09))


func _on_button_up() -> void:
	_animate_cookie(Vector2(0.1, 0.1))


func _animate_cookie(v: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", v, 0.1)
