extends Node

var current_level : int = 7
var level_container : Node
var current_level_instance : Node # Keeps track of the active level

@onready var color_rect = $CanvasLayer/ColorRect

func _ready():
	color_rect.modulate.a = 0
	color_rect.hide()

func start_game():
	current_level = 7
	load_level_instance(current_level)

func player_died():
	current_level = 1
	transition_to_level(current_level)

func advance_level():
	current_level += 1
	
	# Skip level 7
	if current_level == 7:
		current_level = 8
		
	if current_level > 10:
		print("Game Beaten!")
		return 
		
	transition_to_level(current_level)

func transition_to_level(level_num: int):
	# 1. Fade to black
	color_rect.show()
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished 
	
	# 2. Swap the levels while the screen is black
	load_level_instance(level_num)
	
	# 3. Fade back to transparent
	var tween_in = create_tween()
	tween_in.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween_in.finished
	color_rect.hide()

func load_level_instance(level_num: int):
	# Delete the old level if one exists
	if current_level_instance != null:
		current_level_instance.queue_free()
		
	var level_path = "res://levels/Level%d.tscn" % level_num
	var level_scene = load(level_path)
	
	if level_scene:
		# Create a new instance of the level and add it to the container
		current_level_instance = level_scene.instantiate()
		level_container.add_child(current_level_instance)
	else:
		print("ERROR: Could not load level at path: ", level_path)
