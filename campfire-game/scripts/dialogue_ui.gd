extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var type_timer: Timer = $TypeTimer

func _ready():
	panel.hide() # Hide UI when the game starts

# Other scenes will call this function and pass their specific text
func start_dialogue(text: String):
	label.text = text
	label.visible_characters = 0 # Hide all text initially
	panel.show()
	type_timer.start()

# Connect the Timer's 'timeout' signal to this function
func _on_type_timer_timeout():
	if label.visible_characters < label.text.length():
		label.visible_characters += 1
	else:
		type_timer.stop()

func _unhandled_input(event):
	# Close the dialogue if we press E again after the text finishes typing
	if event.is_action_pressed("interact") and panel.visible and type_timer.is_stopped():
		panel.hide()
