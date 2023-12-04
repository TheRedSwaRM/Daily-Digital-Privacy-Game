extends Node

# Signals
signal volume_changed(volume: float)
signal fullscreen_changed(value: bool)
signal save_settings

# Values
@onready var master_volume: float
@onready var fullscreen_value: bool

func _ready():
	_load_settings()
	
	volume_changed.connect(_has_volume_changed)
	fullscreen_changed.connect(_has_fullscreen_changed)
	save_settings.connect(_save_settings)
	
	# Just in case
	_has_volume_changed(master_volume)
	_has_fullscreen_changed(fullscreen_value)

func _has_volume_changed(volume: float):
	master_volume = volume
	# print(master_volume)
	
func _has_fullscreen_changed(value: bool):
	fullscreen_value = value
	# print(fullscreen_value)
	if fullscreen_value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _load_settings():
	# Creates new ConfigFile object
	var config = ConfigFile.new()
	
	# Loads settings with errors in mind.
	var err = config.load("user://settings.cfg")
	
	# If there's no settings, then make some.
	if err != OK:
		_default_settings()
		_save_settings()
		return

	# If not, well, we're getting values. (No need to close, Godot does its job)
	master_volume = config.get_value("Music", "master_volume")
	fullscreen_value = config.get_value("Window", "window_mode")

func _default_settings():
	master_volume = 1.0
	fullscreen_value = true

func _save_settings():
	# Creates new ConfigFile object.
	var config = ConfigFile.new()
	
	# Stores some values.
	config.set_value("Music", "master_volume", master_volume)
	config.set_value("Window", "window_mode", fullscreen_value)

	# It's saving time! (No need to close, Godot already does the job for us)
	config.save("user://settings.cfg")
