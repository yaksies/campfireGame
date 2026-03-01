extends Area2D

# This is now an Array, meaning it can hold multiple pages of text!
@export var dialog_lines: Array[String] = ["Hello there!", "This is page two."] 

@onready var prompt_label = $Label
var can_interact = false

func _ready():
	prompt_label.hide()

func _on_body_entered(body):
	if body.name == "Player": 
		prompt_label.show()
		can_interact = true

func _on_body_exited(body):
	if body.name == "Player":
		prompt_label.hide()
		can_interact = false

func _unhandled_input(event):
	if can_interact and event.is_action_pressed("interact"):
		# We now pass the whole array of lines to the UI
		DialogueUI.start_dialogue(dialog_lines)
		get_viewport().set_input_as_handled()
