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
	
	Events.background_audio_check()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pillow_input_detected():
	if Events.day_counter == 3:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"), "day_3_moment")
		return
	
	if Events.game_time > 18.0:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"), "sleepy_time")
	elif Events.game_time < 10.0:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"), "just_woke_up")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"), "nap_time")
	
	


func _on_clock_pressed():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/room.dialogue"), "clock")


func _on_clock_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)


func _on_clock_mouse_exited():
	GameSettings.change_cursor_look()
