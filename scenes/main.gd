extends Node

@onready var phone = %Phone
@onready var phone_settings = %Phone/PhoneContainer/SettingsPanel		# This is not a pretty solution.
@onready var transition_sprite = $BlinkingEye
@export var debugger_on: bool
@export_file var starting_screen

# Reserved for events... wait do I need it?
@onready var event_done_1: bool = false

# Woops.


func _ready():
	#===========================================================================
	# Mandatory Stuff
	#===========================================================================
	# Adding events
	Events.change_map.connect(_goto_area)
	Events.message_response.connect(_message_received)
	
	# Fix that doesn't fuck up the system. I mean, literally.
	Events.change_map.emit(starting_screen, false)
	
	# For flipping
	phone.flipping_phone.connect(_change_mouse_passing_for_phone)
	
	# For debugging
	
	Events.connection_change.connect(_change_connection_debug)
	Events.location_change.connect(_change_location_debug)
	
	Events.activate_phone.connect(_show_phone)
	Events.deactivate_phone.connect(_hide_phone)
	
	Events.open_blinking_eye.connect(_open_blinking_eye)
	Events.close_blinking_eye.connect(_close_blinking_eye)
	Events.do_full_blink.connect(_do_blink)
	
	
	
	if debugger_on and OS.is_debug_build():
		%Debugger.show()
	
	#===========================================================================
	# Cutscenes
	#===========================================================================
	Events.game_switch_changed.connect(_permissions_set)
	Events.game_switch_changed.connect(_cutscene_social_post)
	Events.game_switch_changed.connect(_cutscene_complete_signup)
	
	#===========================================================================
	# Time Events
	#===========================================================================
	Events.time_check.connect(_cutscene_friend_message)

## First is path. Second if you want to blink. Third is special.
func _goto_area(path: String, can_blink: bool = true, special: bool = false):
	if ResourceLoader.exists(path):
		if can_blink:
			transition_sprite.play("blinking_transition")
			await transition_sprite.animation_finished
		
		call_deferred("_deferred_change_area", path)
		
		if not special and can_blink:
			transition_sprite.play_backwards("blinking_transition")
			await transition_sprite.animation_finished
	
## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path: String):
	var current_scene = get_node("Area")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "Area"
	move_child(current_scene, 0)
	
## If true, allow filter to pass through... else.
func _change_mouse_passing_for_phone(value: bool):
	if value:
		phone.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		phone.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_phone():
	phone.show()

func _hide_phone():
	phone.hide()

func _open_blinking_eye():
	transition_sprite.play_backwards("blinking_transition")
	await transition_sprite.animation_finished

func _close_blinking_eye():
	transition_sprite.play("blinking_transition")
	await transition_sprite.animation_finished

func _do_blink():
	transition_sprite.play("blinking_transition")
	await transition_sprite.animation_finished
		
	transition_sprite.play_backwards("blinking_transition")
	await transition_sprite.animation_finished

#==============================================================================
# Debugger function
#==============================================================================

func _unhandled_input(_event):
	# Prints the game switches
	if Input.is_action_just_pressed("debug_key"):
		print(Events._game_switches)
		print("Connection: " + %ConName.text)
		print("Loccation: " + %LocYesNo.text)

func _change_connection_debug(connection: String):
	%ConName.text = connection
	
func _change_location_debug(value: bool):
	%LocYesNo.text = str(value)

#==============================================================================
# Events
#==============================================================================
func _permissions_set(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "signup_complete":
		Events.game_switch_changed.disconnect(_permissions_set)
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "installation")
		await DialogueManager.dialogue_ended
		
func _cutscene_social_post(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "posted_in_sns":
		Events.game_switch_changed.disconnect(_cutscene_social_post)
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		
#==============================================================================
# Timed Events
#==============================================================================

func _cutscene_friend_message(time: float):
	if Events.day_counter == 1 and time >= 10.0:
		Events.time_check.disconnect(_cutscene_friend_message)
		Events.new_phone_message.emit("Amelie", "Yo, yo, yo!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "How's it going, dude? Having a good break there?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Yeah, it's fine.", true, true)
		Events.new_phone_message.emit("Amelie", "No need to text me, girl.", true, true)

func _cutscene_friend_message_2():
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "And because of that, I got something just for you.")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "There's this new social media app I wanna try, and it's called Friendster!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "And everyone's getting on it, girl! You have to hop in!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "Alright, alright. I'll try.", true, true)
	Events.new_phone_message.emit("Amelie", "And what if I don't?", true, true)

func _cutscene_friend_message_3():
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "The handle's @aMelee. See ya!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Amelie", "[url='www.gglplay.com']Download Link[/url]")
	
	#await get_tree().create_timer(2).timeout
	#Events.new_phone_message.emit("Amelie", "[url='www.gglplay.com']Download Link[/url]")

func _cutscene_complete_signup(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "contacting_friend":
		Events.game_switch_changed.disconnect(_cutscene_complete_signup)
		Events.force_phone_go_to.emit("Messaging", "Amelie")
		Events.new_phone_message.emit("Amelie", "I signed up na.", true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "I knew I could count on you, beb!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Ano yung account name?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", Events.social_media_username, true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Nice one!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Oh... you're not logged in pa?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "I'll try the app tom.", true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Booooooo.")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Amelie", "Okay, beb. See you soon! Mwa, mwa. 😘")
		
#==============================================================================
# Message Events
#==============================================================================

func _message_received(respondent: String, text: String):
	Events.new_phone_message.emit(respondent, text, true)
	var text_message = [respondent, text]
	
	match text_message:
		["Amelie", "Yeah, it's fine."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Amelie", "Good, good. Was wondering you'd be bored to hell.")
			_cutscene_friend_message_2()
			
		["Amelie", "No need to text me, girl."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Amelie", "You don't miss me? :(")
			_cutscene_friend_message_2()
			
		["Amelie", "Alright, alright. I'll try."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Amelie", "Yay! Thanks dude! Anyway...")
			_cutscene_friend_message_3()
			
		["Amelie", "And what if I don't?"]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Amelie", "Oh, you know that shit ain't gonna fly, baby.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Amelie", "Besides. Sooner or later, you're gonna cave.")
			_cutscene_friend_message_3()
		
