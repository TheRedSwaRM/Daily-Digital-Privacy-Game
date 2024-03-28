extends Node2D

@onready var background = $Background/TextureRect
@onready var laptop = $Laptop
@onready var clock = $Clock

# Called when the node enters the scene tree for the first time.
func _ready():
	# Obsolete
	AudioManager.bgs_volume(1)
	
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
	
	# "red_man_hallway_nightmare": false,
	# "red_man_room_nightmare": false,
	if Events.check_game_switch("red_man_hallway_nightmare"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/nightmare.dialogue"), "day_2_nightmare")
		await DialogueManager.dialogue_ended
		Events.change_game_switch("red_man_hallway_nightmare", false)
	
	if Events.check_game_switch("red_man_room_nightmare"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/nightmare.dialogue"), "day_3_nightmare")
		await DialogueManager.dialogue_ended
		Events.change_game_switch("red_man_room_nightmare", false)
	
	# Events.sns_new_notif.emit(Events.NotifType.LIKE, "gay seggs")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_laptop_pressed():
	Events.change_map.emit("res://scenes/laptop/laptop_view.tscn")
	
func _on_clock_pressed():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/room.dialogue"), "clock")


func _on_laptop_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)


func _on_laptop_mouse_exited():
	GameSettings.change_cursor_look()

func _on_clock_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)

func _on_clock_mouse_exited():
	GameSettings.change_cursor_look()
