extends Area2D

func _on_body_entered(body):
	# Check if the object that touched the spikes has a method called "die" 
	# or if it's in the "player" group.
	if body.is_in_group("player"):
		print("Player hit the spikes!")
		
		# Option A: Reload the current level
		get_tree().reload_current_scene()
		
		# Option B: Call a damage function on the player
		# body.take_damage(10)
