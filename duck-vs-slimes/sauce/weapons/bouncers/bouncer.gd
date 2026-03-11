class_name Bouncer
extends CharacterBody2D


const KNOCKBACK_STRENGTH := 50.0
const COLLIDER_DELAY := 0.1

var damage: int
var bounce := 5
var direction: Vector2
var speed := 150
var target: Node2D
var last_collider : Node2D
var same_collider_elapsed := 0.0


func _ready() -> void:
	if target:
		direction = (target.global_position - global_position).normalized()
	else:
		direction = Vector2(1, 0)


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	var c := move_and_collide(direction * speed * delta)
	if not c:
		return
		
	var b = c.get_collider()
	if b.is_in_group("monsters"):
		if b == last_collider and same_collider_elapsed <= COLLIDER_DELAY:
			same_collider_elapsed += delta
		else:
			_monster_collision(b)
			direction = direction.bounce(c.get_normal())
			last_collider = b
			same_collider_elapsed = 0.0
	else:
		direction = direction.bounce(c.get_normal())


func _monster_collision(monster: Monster) -> void:
	if bounce > 0:
		bounce -= 1
	else:
		queue_free()
	monster.call_deferred("hit", damage, direction * KNOCKBACK_STRENGTH)


func _on_ttl_timeout() -> void:
	queue_free()
