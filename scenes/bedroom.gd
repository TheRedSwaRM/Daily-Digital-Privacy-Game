extends Node2D

@onready var main_controller = get_parent()

func _ready():
	print("we good")

func _on_sex_input_detected():
	Events.change_map.emit("res://scenes/intro.tscn")
	#DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sample.dialogue"),"start")
	
