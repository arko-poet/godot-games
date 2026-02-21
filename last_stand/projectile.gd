extends Area2D

const SPEED := 400

var direction : Vector2
var has_collided := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	$Collision.queue_free()
	if not has_collided:
		direction = Vector2.ZERO
		$Sprite.animation = "explode"
		$Sprite.animation_finished.connect(queue_free)
		$Sound.play()
		has_collided = true
	body.hit() # outside of check above means projectiles splash
