extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.bgm_play("res://assets/audio/bgm/pong_game.ogg")
	AudioManager.bgs_volume(0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ball_pong_score(scorer):
	pass # Replace with function body.

func _on_back_button_pressed():
	AudioManager.bgm_stop()
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn")
