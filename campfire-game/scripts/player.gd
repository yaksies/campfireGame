extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Track if we were in the air last frame
var was_in_air = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true # We are in the air, so we are ready to 'land' later
		animated_sprite.play("jump")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# Stop any landing animation if we jump immediately
		anim_player.stop()

	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# LANDING AND GROUND ANIMATION LOGIC
	if is_on_floor():
		if was_in_air:
			# Just touched the ground! Play the land animation via AnimationPlayer
			anim_player.play("land")
			was_in_air = false
		
		# If we are currently playing the "land" animation, 
		# we only interrupt it if the player starts moving.
		if anim_player.is_playing() and anim_player.current_animation == "land":
			if direction != 0:
				# Player is moving, cancel the landing freeze and run
				anim_player.stop()
				animated_sprite.play("run")
			else:
				# Stay in the landing animation until it finishes
				pass 
		else:
			# Normal movement animations when not landing
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")

	# Applies the movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
