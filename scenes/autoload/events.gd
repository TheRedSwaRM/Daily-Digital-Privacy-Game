extends Node

signal change_map(path: String)

@onready var game_switches = {
	"posted_with_location": false
}

@onready var wifi_connection: String
@onready var location: bool
