extends Node

var current_level : int = 7
var level_container : Node
var current_level_instance : Node 

@onready var color_rect = $CanvasLayer/ColorRect
@onready var death_sound = $DeathSound
@onready var title_label = $CanvasLayer/TitleLabel
@onready var ascend_button = $CanvasLayer/AscendButton
@onready var bgm_player = $BGMPlayer

func _ready():
	# Tell this specific node to NEVER stop processing, even if the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	color_rect.modulate.a = 0
	color_rect.hide()

func start_game():
	current_level = 7
	load_level_instance(current_level)

func player_died():
	current_level = 1
	transition_death(current_level)

func advance_level():
	current_level += 1
	
	if current_level == 7:
		current_level = 8
		
	if current_level > 10:
		print("Game Beaten!")
		return 
		
	transition_to_level(current_level)

# --- NORMAL LEVEL TRANSITION (Fast & Black) ---
func transition_to_level(level_num: int):
	color_rect.color = Color(0, 0, 0) 
	
	color_rect.show()
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished 
	
	load_level_instance(level_num)
	
	var tween_in = create_tween()
	tween_in.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween_in.finished
	color_rect.hide()

# --- DEATH TRANSITION (Slow, Red & Loud) ---
func transition_death(level_num: int):
	# 1. Freeze the old level so the dead player can't move
	get_tree().paused = true
	
	color_rect.color = Color(1.0, 0.0, 0.0) 
	color_rect.show()
	
	if death_sound.stream != null:
		death_sound.play()
	
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	await tween.finished 
	
	# 2. Swap to Level 1 while the screen is solid red
	load_level_instance(level_num)
	
	# 3. UNFREEZE TIME HERE!
	# The new level is now active and playable while the screen fades back in.
	get_tree().paused = false
	
	# 4. Fade back to transparent slowly
	var tween_in = create_tween()
	tween_in.tween_property(color_rect, "modulate:a", 0.0, 1.5)
	await tween_in.finished
	
	color_rect.hide()
	color_rect.color = Color(0, 0, 0)

# --- LEVEL LOADER ---
func load_level_instance(level_num: int):
	if current_level_instance != null:
		current_level_instance.queue_free()
		
	var level_path = "res://levels/Level%d.tscn" % level_num
	var level_scene = load(level_path)
	
	if level_scene:
		current_level_instance = level_scene.instantiate()
		level_container.add_child(current_level_instance)
	else:
		print("ERROR: Could not load level at path: ", level_path)
		
		# --- CINEMATIC ENDING ---
# --- CINEMATIC ENDING ---
func trigger_ending():
	color_rect.color = Color(1.0, 1.0, 1.0)
	color_rect.modulate.a = 0.0
	color_rect.show()
	
	title_label.modulate.a = 0.0
	title_label.show()
	
	ascend_button.modulate.a = 0.0
	ascend_button.show()
	
	# 1. Fade screen to white
	var white_tween = create_tween()
	white_tween.tween_property(color_rect, "modulate:a", 1.0, 3.0)
	
	# 2. Fade out music at the exact same time
	# In Godot, -80 decibels (db) is total silence
	if bgm_player.playing:
		var audio_tween = create_tween()
		audio_tween.tween_property(bgm_player, "volume_db", -80.0, 3.0)
		
	# Wait for the 3-second white screen fade to finish
	await white_tween.finished 
	
	# 3. Freeze the game so they can't walk off a cliff
	get_tree().paused = true
	
	# Stop the audio player completely now that it's silent
	bgm_player.stop()
	
	# 4. Wait for a dramatic 1.5 seconds in pure silence
	await get_tree().create_timer(1.5).timeout
	
	# 5. Fade in the game title (takes 2 seconds)
	var text_tween = create_tween()
	text_tween.tween_property(title_label, "modulate:a", 1.0, 2.0)
	await text_tween.finished
	
	# 6. Wait another 1.5 seconds after the title appears
	await get_tree().create_timer(1.5).timeout
	
	# 7. Fade in the Ascend button (takes 1.5 seconds)
	var button_tween = create_tween()
	button_tween.tween_property(ascend_button, "modulate:a", 1.0, 1.5)
	await button_tween.finished


func _on_ascend_button_pressed() -> void:
	get_tree().quit() # Replace with function body.
