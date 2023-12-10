extends Node

signal change_map(path: String)
signal connection_change(name: String)
signal location_change(value: bool)

# For social media posts :skull:
signal sns_add_post(username: String, sns_text: String, loc: String, sns_image: Texture2D)
signal flip_phone()
signal activate_phone()

# Game Switch Change
signal game_switch_changed(key: String, value: bool)

@onready var _game_switches = {
	"intro": false,
	"posted_with_location": false
}

@onready var wifi_connection: String = "None" :
	get:
		return wifi_connection
	set(value):
		wifi_connection = value
		connection_change.emit(value)
		#print("New value: " + value)
	
@onready var location: bool = true :
	get:
		return location
	set(value):
		location = value
		location_change.emit(value)

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
	
	#print(game_switches)
