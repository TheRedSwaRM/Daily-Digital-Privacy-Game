extends Node2D

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
			await DialogueManager.dialogue_ended
			Events.change_game_switch("night_intro", true)

		return

	if not Events.check_game_switch("intro"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		Events.change_game_switch("intro", true)
		
		# We need this for really stupid reasons. It just works. ;-;
		Events.new_phone_message.emit("Amelie", "[url='https://gglplay.com']Download Link[/url]")
	
	# Events.sns_new_notif.emit(Events.NotifType.LIKE, "gay seggs")
	
	AudioManager.bgm_play("res://assets/audio/bgm/room_ambience.ogg")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_laptop_pressed():
	if Events.check_game_switch("night"):
		if Events.check_game_switch("laptop_checked") == false:
			AudioManager.sfx_play("res://assets/audio/sfx/laptop_startup_distorted.mp3")
			Events.change_game_switch("laptop_checked", true)
			laptop.texture_normal = load("res://assets/images/bg/laptop_horror_night.png")
		else:
			DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "laptop_scare")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "laptop")
	
	


func _on_clock_pressed():
	match randi() % 3:
		0:
			Events.game_time = 5.5
		1:
			Events.game_time = 12
		2:
			Events.game_time = 17
	print(Events.game_time)
	#DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/room.dialogue"), "clock")



func _on_laptop_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)


func _on_laptop_mouse_exited():
	GameSettings.change_cursor_look()


func _on_clock_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)


func _on_clock_mouse_exited():
	GameSettings.change_cursor_look()
