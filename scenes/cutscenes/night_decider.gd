extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.change_map.emit("res://scenes/cutscenes/day_indicator.tscn", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
