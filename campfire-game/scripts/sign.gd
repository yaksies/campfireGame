extends Area2D

# The @export keyword makes this variable appear in the Inspector!
@export var sign_text: String = "Default sign text." 

@onready var prompt_label = $Label
var can_interact = false

func _ready():
	prompt_label.hide()

# Connect the Area2D's 'body_entered' signal to this function
func _on_body_entered(body):
	if body.name == "Player": # Make sure your player node is actually named "Player"
		prompt_label.show()
		can_interact = true

# Connect the Area2D's 'body_exited' signal to this function
func _on_body_exited(body):
	if body.name == "Player":
		prompt_label.hide()
		can_interact = false

func _unhandled_input(event):
	# If the player is close enough and presses E
	if can_interact and event.is_action_pressed("interact"):
		# Call our global Autoloaded UI and pass this specific sign's text
		DialogueUI.start_dialogue(sign_text)
