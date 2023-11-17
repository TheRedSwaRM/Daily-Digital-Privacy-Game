extends Node2D


func _on_sex_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sample.dialogue"),"start")
	
