extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
<<<<<<< HEAD
	
	timer.start()

=======
	# 1. Check if the body is actually the player (prevents slimes killing slimes)
	if body.name == "Player":
		print("You died!")
		
		# 2. Slow down time
		Engine.time_scale = 0.5
		
		# 3. Use set_deferred to disable collision safely. 
		# Removing the node can cause errors if other scripts still need it.
		# It is safer to just disable it:
		var shape = body.get_node_or_null("CollisionShape2D")
		if shape:
			shape.set_deferred("disabled", true)
		
		# 4. Optional: If the player has a 'die' function, call it
		if body.has_method("die"):
			body.die()
			
		timer.start()
>>>>>>> 89a09c0997ca2725a00d7b64a9444cc57ddc9b87

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	
	# Ensure GameManager exists in your Autoloads!
	if GameManager:
		GameManager.player_died()
	else:
		# Fallback if GameManager isn't set up yet
		get_tree().reload_current_scene()
