extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var was_in_air = false

# --- LANTERN VARIABLES ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var lantern: Node2D = $Lantern # Ensure this matches your Lantern's node name exactly
@onready var lantern_pos: Marker2D = $LanternPos # Ensure you have a Marker2D node added

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
		animated_sprite.play("jump")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_player.stop()

	# Get movement direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip Logic (Sprite AND Lantern Position)
	if direction > 0:
		animated_sprite.flip_h = false
		# Move the marker to the right side of the player
		lantern_pos.position.x = abs(lantern_pos.position.x)
	elif direction < 0:
		animated_sprite.flip_h = true
		# Move the marker to the left side of the player
		lantern_pos.position.x = -abs(lantern_pos.position.x)

	# --- MAKE LANTERN FOLLOW ---
	if lantern and lantern_pos:
		# Use lerp for a smooth 'swinging' follow effect, 
		# or just use = lantern_pos.position for instant snapping
		lantern.position = lantern.position.lerp(lantern_pos.position, 0.2)
		
	# Animation State Machine
	if is_on_floor():
		if was_in_air:
			anim_player.play("land")
			was_in_air = false
		
		if anim_player.is_playing() and anim_player.current_animation == "land":
			if direction != 0:
				anim_player.stop()
				animated_sprite.play("run")
		else:
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
