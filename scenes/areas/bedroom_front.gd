extends Node2D
@onready var bathroom = $ToBathroom
@onready var background = $Control/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("night"):
		background.texture = load("res://assets/images/bg/room2_night.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_to_bathroom_input_detected():
	if Events.check_game_switch("night"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "bathroom_check")
	else:
		Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn")
