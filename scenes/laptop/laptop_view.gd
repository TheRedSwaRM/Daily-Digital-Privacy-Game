extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_pong_score(scorer):
	pass # Replace with function body.

func _on_back_button_pressed():
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn")