extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("intro"):
		AudioManager.bgm_play("res://assets/audio/bgm/room_ambience.ogg")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		Events.change_game_switch("intro", true)		
		AudioManager.bgm_play("res://assets/audio/bgm/room_ambience.ogg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_laptop_pressed():
	pass


