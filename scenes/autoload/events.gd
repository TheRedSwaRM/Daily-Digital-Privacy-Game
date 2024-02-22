extends Node

enum NotifType {
	FOLLOW,
	LIKE,
	SHARE
}

## First is path. Second if you want to blink. Third is special.
signal change_map(path: String, can_blink: bool, special: bool)

signal connection_change(name: String)
signal location_change(value: bool)

# For social media posts :skull:

signal sns_add_post(username: String, sns_text: String, loc: String, sns_image: Texture2D)
## FOLLOW, LIKE, SHARE
signal sns_new_notif(post_type: NotifType, username: String)
signal flip_phone
signal activate_phone
signal deactivate_phone
signal ring_phone
signal open_blinking_eye
signal close_blinking_eye
signal do_full_blink

# Game Switch Change
signal game_switch_changed(key: String, value: bool)

# Dialogue selection
signal response_taken

# For adding new messages to the phone :skull:
signal new_phone_message(user_name: String, message: String, is_player: bool, is_option: bool)


# Back button activated. An all-around signal passer for everything.
# Very intuitive design.
signal back_button_pressed
signal link_pressed(link_data: String)

signal force_phone_go_to(module: String)

#===============================================================================
# For Time Control
#===============================================================================

## Changes the time currently in float.
signal change_time(time: float)
signal change_time_speed(game_speed: int)
signal time_check(time: float)
var game_time: float:
	set(value):
		game_time = value
		change_time.emit(game_time)
		time_check.emit(game_time)
		
# Hamstrung solution to disallow any sounds for the phone.
var phones_sounds: bool = false
var day_counter: int = 1 :
	get:
		return day_counter
	set(value):
		print("Today is Day " + str(value))
		day_counter = value

@onready var _game_switches = {
	"intro": false,
	"night": false,
	"laptop_checked": false,
	"night_intro": false,
	"app_installed": false,
	"posted_in_sns": false,
	"signup_complete": false,
	"shower_taken": false,
	
	# Data Privacy Violations
	"WARNING_permissions_set": false,
	"WARNING_posted_with_location": false,
}

@onready var wifi_connection: String = "None" :
	get:
		return wifi_connection
	set(value):
		wifi_connection = value
		connection_change.emit(value)
		#print("New value: " + value)
	
@onready var location: bool = false :
	get:
		return location
	set(value):
		print("Current Loc Value set to " + str(value))
		location = value
		location_change.emit(value)

#===============================================================================
# Social Media Variables
#===============================================================================

signal get_social_media_name(user_name: String)
var social_media_username: String
var social_media_location: String = "Yakal St."

func _ready():
	pass

func change_game_switch(key: String, value: bool):
	_game_switches[key] = value
	print(key + " is now " + str(value))
	game_switch_changed.emit(key, value)

func check_game_switch(key: String):
	return _game_switches[key]

## What it says in the tin, especially in the event that we're going back to the main menu.
func reset_all():
	for key in _game_switches:
		_game_switches[key] = false
	
	wifi_connection = "None"
	location = true

func quit_game():
	AudioManager.bgm_stop()
	Events.reset_all()
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func mouse_left_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		return true
	else:
		return false

#===============================================================================
# DEBUG FUNCTIONS
#===============================================================================
