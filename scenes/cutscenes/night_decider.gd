extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pause_game_time.emit(true)
	Events.game_time = 12.0
	
	if Events.check_game_switch("WARNING_permissions_set") and Events.day_counter == 1:
		Events.change_map.emit("res://scenes/cutscenes/red_man_hallway.tscn", false)
	elif Events.check_game_switch("WARNING_posted_with_location") and Events.day_counter == 2:
		Events.change_map.emit("res://scenes/cutscenes/creep_incoming.tscn", false)
	else:
		Events.change_map.emit("res://scenes/cutscenes/day_indicator.tscn", false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
