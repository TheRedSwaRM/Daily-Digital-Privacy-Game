extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("WARNING_permissions_set"):
		Events.change_map.emit("res://scenes/cutscenes/day_indicator.tscn", false)
	else:
		Events.change_map.emit("res://scenes/cutscenes/red_man_hallway.tscn", false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
