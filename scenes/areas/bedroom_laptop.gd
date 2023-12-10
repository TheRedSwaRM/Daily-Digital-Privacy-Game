extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not Events.game_switches["intro"]:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		Events.game_switches["intro"] = true
		
	if Events.game_switches["intro"]:
		AudioManager.bgm_play("res://assets/audio/bgm/gnossienne_1.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_laptop_pressed():
	pass


