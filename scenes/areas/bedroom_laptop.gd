extends Control

@onready var background = $Background/TextureRect
@onready var laptop = $Laptop
@onready var clock = $Clock

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("night"):
		background.texture = load("res://assets/images/bg/room1_night.png")
		if Events.check_game_switch("laptop_checked"):
			laptop.texture_normal = load("res://assets/images/bg/laptop_horror_night.png")
		else:
			laptop.texture_normal = load("res://assets/images/bg/laptop_night.png")
		clock.texture_normal = load("res://assets/images/bg/clock_side_night.png")
		
		if not Events.check_game_switch("night_intro"):
			DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "intro")
			Events.change_game_switch("night_intro", true)

		return

	if Events.check_game_switch("intro"):
		AudioManager.bgm_play("res://assets/audio/bgm/room_ambience.ogg")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		Events.change_game_switch("intro", true)		
		AudioManager.bgm_play("res://assets/audio/bgm/room_ambience.ogg")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_laptop_pressed():
	if Events.check_game_switch("night"):
		if Events.check_game_switch("laptop_checked") == false:
			Events.change_game_switch("laptop_checked", true)
			laptop.texture_normal = load("res://assets/images/bg/laptop_horror_night.png")
		else:
			DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "laptop_scare")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "laptop")


