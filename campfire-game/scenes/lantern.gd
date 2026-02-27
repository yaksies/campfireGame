extends Sprite2D # Or Node2D, AnimatedSprite2D, etc.

@onready var lantern_pos: Marker2D = $LanternPos
@onready var lantern: Node2D = $Lantern # Change 'Lantern' to your node's name

func _physics_process(delta: float) -> void:
	# ... your existing movement code ...

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
		# Move the marker to the right side
		lantern_pos.position.x = abs(lantern_pos.position.x) 
	elif direction < 0:
		animated_sprite.flip_h = true
		# Move the marker to the left side
		lantern_pos.position.x = -abs(lantern_pos.position.x)

	# Make the lantern follow the marker
	lantern.position = lantern_pos.position
