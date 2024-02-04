extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mirror_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/bathroom.dialogue"), "mirror")


func _on_faucet_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/bathroom.dialogue"), "faucet")


func _on_toilet_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/bathroom.dialogue"), "toilet")
