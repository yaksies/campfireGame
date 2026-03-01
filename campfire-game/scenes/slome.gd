extends Node2D

const SPEED = 60
var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		# Optional: flip the sprite if you have one
	
	if ray_cast_left.is_colliding():
		direction = 1
		
	position.x += direction * SPEED * delta

# This function runs when something enters the Slime's Area2D
func _on_kill_zone_body_entered(body: Node2D) -> void:
	# Check if the object entering is actually the Player
	# (Ensure your Player script has "class_name Player" at the top 
	# OR check the name)
	if body.name == "Player": 
		print("Player died!")
		die()

func die():
	# For now, we'll just reload the current scene
	get_tree().reload_current_scene()
