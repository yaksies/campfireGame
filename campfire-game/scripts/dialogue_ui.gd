extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/RichTextLabel
@onready var type_timer = $TypeTimer
@onready var type_sound = $TypeSound

var lines_queue: Array[String] = []
var current_line_index: int = 0
var is_typing: bool = false

func _ready():
	panel.hide()

func start_dialogue(lines: Array[String]):
	if panel.visible: return 
	
	lines_queue = lines
	current_line_index = 0
	panel.show()
	show_current_line()

func show_current_line():
	is_typing = true
	label.text = lines_queue[current_line_index]
	label.visible_characters = 0
	type_timer.start()

func _on_type_timer_timeout():
	if label.visible_characters < label.text.length():
		label.visible_characters += 1
		
		# A pro trick: randomly shift the pitch slightly every letter 
		# so the sound effect doesn't feel like a repetitive machine gun
		type_sound.pitch_scale = randf_range(0.8
	, 1.4)
		type_sound.play()
	else:
		finish_typing()

func finish_typing():
	type_timer.stop()
	is_typing = false
	label.visible_characters = -1 
	
	# Take a snapshot of the current page number
	var saved_index = current_line_index
	
	# Wait for 2 seconds
	await get_tree().create_timer(2.0).timeout
	
	# ONLY auto-advance if the player hasn't manually skipped to a new page
	if panel.visible and current_line_index == saved_index and not is_typing:
		advance_dialogue()

func advance_dialogue():
	if not panel.visible: return 

	current_line_index += 1
	
	if current_line_index < lines_queue.size():
		show_current_line()
	else:
		panel.hide()

# Change this from _unhandled_input to _input
func _input(event): 
	if panel.visible and event.is_action_pressed("interact"):
		# The UI now eats the input FIRST, so the Sign never sees it!
		get_viewport().set_input_as_handled() 
		
		if is_typing:
			finish_typing()
		else:
			advance_dialogue()
