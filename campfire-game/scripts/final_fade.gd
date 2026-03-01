extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Disable the trigger so it doesn't fire twice
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Trigger the grand finale!
		GameManager.trigger_ending()
