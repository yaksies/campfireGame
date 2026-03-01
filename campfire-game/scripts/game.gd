extends Node

@onready var levels_container = $Levels

func _ready():
	# Give the GameManager a reference to our empty container
	GameManager.level_container = levels_container
	
	# Start the game at level 7
	GameManager.start_game()
