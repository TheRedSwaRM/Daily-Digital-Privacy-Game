extends Node

# Signals
signal master_volume_changed(volume: float)
signal fullscreen_changed(value: bool)
signal music_volume_changed(volume: float)
signal sfx_volume_changed(volume: float)
signal save_settings

# Values
@onready var master_volume: float
@onready var fullscreen_value: bool
@onready var music_volume: float
@onready var sfx_volume: float

var default_cursor = load(ProjectSettings.get_setting("display/mouse_cursor/custom_image"))
var cursor_interact = preload("res://assets/images/cursor/cursor_interact.png")
var cursor_left = preload("res://assets/images/cursor/cursor_left.png")
var cursor_right = preload("res://assets/images/cursor/cursor_right.png")
var cursor_up = preload("res://assets/images/cursor/cursor_up.png")
var cursor_down = preload("res://assets/images/cursor/cursor_down.png")
var cursor_phone_up = preload("res://assets/images/cursor/cursor_up2.png")
var cursor_phone_down = preload("res://assets/images/cursor/cursor_down2.png")


enum CursorLook {
	DEFAULT,
	INTERACT,
	LEFT,
	RIGHT,
	UP,
	DOWN,
	PHONE_UP,
	PHONE_DOWN
}

func _ready():
	_load_settings()
	
	master_volume_changed.connect(_has_master_volume_changed)
	fullscreen_changed.connect(_has_fullscreen_changed)
	music_volume_changed.connect(_has_music_volume_changed)
	sfx_volume_changed.connect(_has_sfx_volume_changed)
	save_settings.connect(_save_settings)
	
	# Just in case
	_has_master_volume_changed(master_volume)
	_has_music_volume_changed(music_volume)
	_has_sfx_volume_changed(sfx_volume)
	_has_fullscreen_changed(fullscreen_value)

func _has_master_volume_changed(volume: float):
	master_volume = volume
	# print(master_volume)
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))

func _has_music_volume_changed(volume: float):
	music_volume = volume
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),linear_to_db(music_volume))

func _has_sfx_volume_changed(volume: float):
	sfx_volume = volume
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(sfx_volume))

func _has_fullscreen_changed(value: bool):
	fullscreen_value = value
	# print(fullscreen_value)
	if fullscreen_value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

#DEFAULT,
#LEFT,
#RIGHT,
#UP,
#DOWN,
#PHONE

func change_cursor_look(value: int = CursorLook.DEFAULT):
	match value:
		CursorLook.DEFAULT:
			Input.set_custom_mouse_cursor(default_cursor)
		CursorLook.INTERACT:
			Input.set_custom_mouse_cursor(cursor_interact)
		CursorLook.LEFT:
			Input.set_custom_mouse_cursor(cursor_left)
		CursorLook.RIGHT:
			Input.set_custom_mouse_cursor(cursor_right)
		CursorLook.UP:
			Input.set_custom_mouse_cursor(cursor_up)
		CursorLook.DOWN:
			Input.set_custom_mouse_cursor(cursor_down)
		CursorLook.PHONE_UP:
			Input.set_custom_mouse_cursor(cursor_phone_up)
		CursorLook.PHONE_DOWN:
			Input.set_custom_mouse_cursor(cursor_phone_down)
		
			
func _default_settings():
	master_volume = 1.0
	music_volume = 1.0
	sfx_volume = 1.0
	fullscreen_value = true

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
	music_volume = config.get_value("Music", "music_volume")
	sfx_volume = config.get_value("Music", "sfx_volume")
	fullscreen_value = config.get_value("Window", "window_mode")

func _save_settings():
	# Creates new ConfigFile object.
	var config = ConfigFile.new()
	
	# Stores some values.
	config.set_value("Music", "master_volume", master_volume)
	config.set_value("Music", "music_volume", music_volume)
	config.set_value("Music", "sfx_volume", sfx_volume)
	config.set_value("Window", "window_mode", fullscreen_value)

	# It's saving time! (No need to close, Godot already does the job for us)
	config.save("user://settings.cfg")
