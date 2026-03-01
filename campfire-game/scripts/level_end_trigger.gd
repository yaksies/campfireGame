extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Disable the trigger so it doesn't fire multiple times
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Tell the manager to handle the fade and level change
		GameManager.advance_level()
