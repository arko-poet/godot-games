class_name Player
extends CharacterBody2D

signal died
signal hp_changed
signal xp_changed
signal level_changed
var speed := 150.0
var xp := 0
var next_level_xp := 10
var max_hp := 100
var hp := 100
var monsters_in_contact : Array[Monster] = []
var level := 1
@onready var sprite: AnimatedSprite2D = $Sprite


func _physics_process(_delta: float) -> void:
	# movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	velocity = direction.normalized() * speed
	if velocity.x != 0 or velocity.y != 0:
		sprite.animation = "walk"
	else:
		sprite.animation = "idle"
	sprite.flip_h = direction.x < 0.0
	move_and_slide()


func add_xp(value : int) -> void:
	xp += value
	if xp >= next_level_xp:
		xp = xp - next_level_xp
		level += 1
		level_changed.emit()
	xp_changed.emit()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Monster:
		monsters_in_contact.append(body)


func _on_hurt_box_body_exited(body: Node2D) -> void:
	monsters_in_contact.erase(body)


func _on_hp_drain_timer_timeout() -> void:
	var total_damage := 0
	for monster in monsters_in_contact:
		total_damage += monster.damage
	var original_hp = hp
	hp = maxi(hp - total_damage, 0)
	if original_hp != hp:
		hp_changed.emit()
		if hp == 0:
			died.emit()
	
