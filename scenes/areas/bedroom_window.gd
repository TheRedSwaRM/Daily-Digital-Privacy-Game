extends Node2D

@onready var cloud_animation = $AnimationPlayer
@onready var background = $Background/RoomBackground
@onready var clouds = $Background/Clouds
@onready var clock = $Clock
# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("night"):
		clouds.hide()
		clock.hide()
		background.texture = load("res://assets/images/bg/room3_night2.png")
	else:
		cloud_animation.play("clouds")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pillow_input_detected():
	if Events.check_game_switch("night"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "pillow_check")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"))


func _on_clock_pressed():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/room.dialogue"), "clock")
