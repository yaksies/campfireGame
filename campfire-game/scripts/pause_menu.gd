extends CanvasLayer

@onready var main_menu: Control = $MainMenu
@onready var settings_menu: Control = $SettingsMenu

# Sliders
@onready var master_slider = $SettingsMenu/VBoxContainer/MasterSlider
@onready var music_slider = $SettingsMenu/VBoxContainer/MusicSlider
@onready var sfx_slider = $SettingsMenu/VBoxContainer/SFXSlider

const SETTINGS_PATH = "user://settings.cfg"

# Audio Bus Indices
var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready():
	hide()
	settings_menu.hide()
	load_settings()
	
func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()
		

func toggle_pause():
	# If the game is currently unpaused, pause it. If paused, unpause it.
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	if is_paused:
		show()
		main_menu.show()
		settings_menu.hide()
	else:
		hide()

# --- BUTTON SIGNALS ---
# (Remember to connect the 'pressed()' signals of your buttons to these functions!)

func _on_resume_button_pressed():
	toggle_pause()

func _on_settings_button_pressed():
	main_menu.hide()
	settings_menu.show()

func _on_back_button_pressed():
	settings_menu.hide()
	main_menu.show()
	save_settings()

func _on_exit_button_pressed():
	get_tree().quit()

# --- AUDIO SLIDER SIGNALS ---
# (Connect the 'value_changed(value)' signals of your sliders to these functions!)

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	
func save_settings():
	var config = ConfigFile.new()
	
	# Store the slider values under an "audio" section
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	
	# Save it to the player's hard drive
	config.save(SETTINGS_PATH)

func load_settings():
	var config = ConfigFile.new()
	
	# Check if the file exists and loads successfully
	if config.load(SETTINGS_PATH) == OK:
		# Update the sliders. The '1.0' is a default fallback value just in case.
		master_slider.value = config.get_value("audio", "master", 1.0)
		music_slider.value = config.get_value("audio", "music", 1.0)
		sfx_slider.value = config.get_value("audio", "sfx", 1.0)
		
		# Apply those loaded values immediately to the actual audio engine
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_slider.value))
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_slider.value))
