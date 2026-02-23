extends Node2D

const SCROLL_SPEED = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera.global_position.y += delta * -SCROLL_SPEED
	$LeftWall.position.y += delta * -SCROLL_SPEED
	$RightWall.position.y += delta * -SCROLL_SPEED
