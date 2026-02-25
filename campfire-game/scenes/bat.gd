extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	# If velocity is nearly 0, play idle. If moving, play fly.
	if velocity.length() > 0.1:
		if sprite.animation != "Fly": # Replace with your animation name
			sprite.play("Fly")
	else:
		if sprite.animation != "Idle":
			sprite.play("Idle")
			
	# Simple flip logic: if moving left, flip the sprite
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	move_and_slide()

# Call this function from your AI or Input code
func perform_attack():
	sprite.play("Attack")


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "Attack":
		sprite.play("Idle") # Or "Fly" depending on your preference
