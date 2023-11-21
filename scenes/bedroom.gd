extends Node2D

@onready var main_controller = get_parent()

func _ready():
	print("we good")

func _on_sex_input_detected():
	main_controller.goto_area("res://scenes/intro.tscn")
	#DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sample.dialogue"),"start")
	
