extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# --- LANTERN & SPRITE NODES ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var lantern: Node2D = $Lantern
@onready var lantern_pos: Marker2D = $LanternPos

func _physics_process(delta: float) -> void:
	# 1. Add Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Get Input Direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# 4. Movement & Friction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 5. Flip Logic (Sprite & Lantern Position)
	if direction > 0:
		animated_sprite.flip_h = false
		lantern_pos.position.x = abs(lantern_pos.position.x)
	elif direction < 0:
		animated_sprite.flip_h = true
		lantern_pos.position.x = -abs(lantern_pos.position.x)

	# 6. Lantern Following (Smooth Lerp)
	if lantern and lantern_pos:
		lantern.position = lantern.position.lerp(lantern_pos.position, 0.2)
		
	# Apply physics
	move_and_slide()
	
	# Update animations after movement is calculated
	update_animations(direction)

func update_animations(direction: float) -> void:
	if not is_on_floor():
		# Play jump if in the air
		animated_sprite.play("jump")
	elif direction != 0:
		# Play run if moving on the ground
		animated_sprite.play("run")
	else:
		# Play idle if standing still on the ground
		animated_sprite.play("idle")
