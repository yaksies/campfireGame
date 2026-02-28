extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# --- AUDIO SETTINGS ---
@onready var footstep_sound: AudioStreamPlayer2D = $FootstepSound # Make sure the node name matches!
@export var step_interval: float = 0.35  # How fast the steps play
var step_timer: float = 0.0

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
	
	# 7. Footstep Logic
	handle_footsteps(delta, direction)
	
	# Update animations after movement is calculated
	update_animations(direction)

func handle_footsteps(delta: float, direction: float) -> void:
	# Only play sound if on floor and actually moving
	if is_on_floor() and direction != 0:
		step_timer -= delta
		if step_timer <= 0:
			# Play the sound with a tiny bit of random pitch for realism
			footstep_sound.pitch_scale = randf_range(0.8, 1.2)
			footstep_sound.play()
			step_timer = step_interval
	else:
		# Reset timer so the next time you move, it clicks immediately
		step_timer = 0.0

func update_animations(direction: float) -> void:
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
