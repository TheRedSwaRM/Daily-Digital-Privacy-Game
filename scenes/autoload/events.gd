extends Node

signal change_map(path: String)
signal debug_connection_change(name: String)
signal debug_location_change(value: bool)

@onready var game_switches = {
	"posted_with_location": false
}

@onready var wifi_connection: String :
	get:
		return wifi_connection
	set(value):
		wifi_connection = value
		debug_connection_change.emit(value)
		print("New value: " + value)
	
@onready var location: bool :
	get:
		return location
	set(value):
		location = value
		debug_location_change.emit(value)
