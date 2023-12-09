extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.bgm_play("res://assets/audio/bgm/gnossienne_1.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_laptop_pressed():
	#print("presesd")
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
