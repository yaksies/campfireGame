extends Area2D

func _on_body_entered(body):
	# Check if the object that touched the spikes has a method called "die" 
	# or if it's in the "player" group.
	if body.is_in_group("player"):
		print("Player hit the spikes!")

		GameManager.player_died()
 
