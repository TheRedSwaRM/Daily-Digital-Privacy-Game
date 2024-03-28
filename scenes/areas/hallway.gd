extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.bgs_volume(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_to_room_input_detected():
	AudioManager.sfx_play("res://assets/audio/sfx/door_open.mp3")

func _on_door_left_interact_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/hallway.dialogue"), "left_door")

func _on_door_right_interact_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/hallway.dialogue"), "right_door")

func _on_door_hallway_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/hallway.dialogue"), "end_hall")
