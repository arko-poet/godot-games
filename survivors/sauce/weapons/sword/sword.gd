extends Weapon

const SWIPE_RADIUS := 16 ## distance from parent center to sword handle
const HALF_CONE := PI * 0.25

var attack_time := 0.25
var knockback_magnitude := 100.0

@onready var hit_box: CollisionShape2D = $HitBox/Collision


func _ready() -> void:
	super._ready()
	_deactivate()
	
	
func _attack() -> void:
	position = (target.global_position - global_position).normalized() * SWIPE_RADIUS
	rotation = position.normalized().angle()
	var t: Tween = create_tween()
	t.tween_method(_sword_swipe, rotation - HALF_CONE, rotation + HALF_CONE, attack_time)
	t.finished.connect(_deactivate)
	_activate()
	t.play()


func _sword_swipe(angle: float) -> void:
	position = Vector2(cos(angle), sin(angle)) * SWIPE_RADIUS
	rotation = position.normalized().angle()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Monster:
		var knockback := knockback_magnitude * (body.global_position - global_position).normalized()
		body.call_deferred("hit", int(base_damage * damage_multiplier), knockback)


func _activate():
	show()
	hit_box.disabled = false


func _deactivate():
	hide()
	hit_box.disabled = true
