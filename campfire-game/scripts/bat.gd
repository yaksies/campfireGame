extends CharacterBody2D

@export var speed: float = 160.0
@export var accel: float = 300.0
@export var wander_radius: float = 150.0 # How far it wanders from its start

@onready var anim = $AnimatedSprite2D
var player = null
var start_position: Vector2
var target_position: Vector2

enum {IDLE, CHASE, ATTACK}
var state = IDLE

func _ready():
	start_position = global_position
	target_position = get_random_target()
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	match state:
		IDLE:
			idle_wander_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state()
	
	move_and_slide()

func idle_wander_state(delta):
	anim.play("Idle")
	
	# Move toward the random target position
	var direction = (target_position - global_position).normalized()
	velocity = velocity.move_toward(direction * (speed * 0.5), accel * delta) # Moves at half speed while idling
	
	# Flip sprite based on movement
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0
	
	# If we reached the target, pick a new one
	if global_position.distance_to(target_position) < 10.0:
		target_position = get_random_target()

func get_random_target() -> Vector2:
	var random_offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	return start_position + random_offset

func chase_state(delta):
	anim.play("Idle")
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * speed, accel * delta)
		anim.flip_h = velocity.x < 0
	else:
		state = IDLE

func attack_state():
	velocity = Vector2.ZERO 
	anim.play("Attack")

# --- SIGNALS ---

func _on_detection_range_body_entered(body):
	if body.is_in_group("player"):
		state = CHASE

func _on_detection_range_body_exited(body):
	if body.is_in_group("player"):
		state = IDLE
		# When returning to idle, reset wander center to where it lost the player
		start_position = global_position 
		target_position = get_random_target()

func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		state = ATTACK

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "Attack":
		state = CHASE
