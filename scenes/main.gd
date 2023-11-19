extends Node2D

func _ready():
	print("we good")

func _on_sex_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sample.dialogue"),"start")
	
