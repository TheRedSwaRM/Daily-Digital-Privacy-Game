extends Node

@onready var phone = %Phone
@onready var phone_settings = %Phone/PhoneContainer/PhoneFunctions/SettingsPanel		# This is not a pretty solution.
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
	Events.game_switch_changed.connect(_hacker_attack_message)
	Events.game_switch_changed.connect(_hacker_spam_attack)
	Events.game_switch_changed.connect(_actual_spam_attack)
	Events.game_switch_changed.connect(_if_hacked_then_call_accepted)
	Events.game_switch_changed.connect(_force_game_end)
	Events.game_switch_changed.connect(_player_gets_hacked_like_an_idiot)
	#Events.game_switch_changed.connect(_alison_texts_back_1)
	
	#===========================================================================
	# Time Events
	#===========================================================================
	Events.time_check.connect(_cutscene_friend_message)
	Events.time_check.connect(_cutscene_call)

	
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
		for switches in Events._game_switches:
			if Events.check_game_switch(str(switches)):
				print(str(switches) + ": " + str(Events.check_game_switch(str(switches))))
		print(Events.day_counter)
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

# Day 3 Events

#func _alison_texts_back_1(key: String, _value: bool):
	#if Events.check_game_switch(key) && key == "ALISON_call_rejected":
		#Events.game_switch_changed.disconnect(_alison_texts_back_1)
		#await get_tree().create_timer(10).timeout
		#Events.new_phone_message.emit("Unknown", "girl, you there?")
		#Events.new_phone_message.emit("Unknown", "Who's this?", true, true)
		#Events.new_phone_message.emit("Unknown", "[Block phone number]", true, true)




#==============================================================================
# Timed Events
#==============================================================================

func _cutscene_friend_message(time: float):
	if Events.day_counter == 1 and time >= 10.0:
		Events.time_check.disconnect(_cutscene_friend_message)
		Events.new_phone_message.emit("Alison", "Yo, yo, yo!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "How's it going, dude? Having a good break there?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Yeah, it's fine.", true, true)
		Events.new_phone_message.emit("Alison", "No need to text me, girl.", true, true)

func _cutscene_call(time: float):
	if Events.day_counter == 3 and time >= 10.0:
		Events.time_check.disconnect(_cutscene_call)
		Events.incoming_call.emit(0)
		
func _cutscene_friend_message_2():
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "And because of that, I got something just for you.")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "There's this new social media app I wanna try, and it's called Friender!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "And everyone's getting on it, girl! You have to hop in!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "Alright, alright. I'll try.", true, true)
	Events.new_phone_message.emit("Alison", "And what if I don't?", true, true)

func _cutscene_friend_message_3():
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "The handle's @aMelee. See ya!")
	await get_tree().create_timer(1).timeout
	Events.new_phone_message.emit("Alison", "[url='www.gglplay.com']Download Link[/url]")
	
	#await get_tree().create_timer(2).timeout
	#Events.new_phone_message.emit("Alison", "[url='www.gglplay.com']Download Link[/url]")

func _cutscene_complete_signup(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "contacting_friend":
		Events.game_switch_changed.disconnect(_cutscene_complete_signup)
		Events.force_phone_go_to.emit("Messaging", "Alison")
		Events.new_phone_message.emit("Alison", "I signed up na.", true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "I knew I could count on you, beb!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Ano yung account name?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", Events.social_media_username, true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Nice one!")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Oh... you're not logged in pa?")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "I'll try the app tom.", true)
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Booooooo.")
		await get_tree().create_timer(1).timeout
		Events.new_phone_message.emit("Alison", "Okay, beb. See you soon! Mwa, mwa. 😘")
		
#==============================================================================
# Message Events
#==============================================================================

func _message_received(respondent: String, text: String):
	var text_message = [respondent, text]
	
	# In case of blocking
	match text_message:
		["Unknown", "[Block her out of annoyance]"]:
			pass
		["Unknown", "[Block phone number]"]:
			pass
		_:
			Events.new_phone_message.emit(respondent, text, true)
	
	
	
	# Events
	match text_message:
		["Alison", "Yeah, it's fine."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Good, good. Was wondering you'd be bored to hell.")
			_cutscene_friend_message_2()
			
		["Alison", "No need to text me, girl."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "You don't miss me? :(")
			_cutscene_friend_message_2()
			
		["Alison", "Alright, alright. I'll try."]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Yay! Thanks dude! Anyway...")
			_cutscene_friend_message_3()
			
		["Alison", "And what if I don't?"]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Oh, you know that shit ain't gonna fly, baby.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Besides. Sooner or later, you're gonna cave.")
			_cutscene_friend_message_3()
		
		#["Unknown", "Who's this?"]:
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "it's me, alison. im using a new number right now.")
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "i'm kinda pissed you didn't accept my call.")
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "Well, how am i supposed to know it was you?", true, true)
			#Events.new_phone_message.emit("Unknown", "[Block phone number]", true, true)
		#
		#["Unknown", "Well, how am i supposed to know it was you?"]:
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "okay, remember the time you vomitted on my bed when we got back after that one party?")
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "Okay, maybe it's you.", true, true)
			#Events.new_phone_message.emit("Unknown", "[Block her out of annoyance]", true, true)
		#
		#["Unknown", "[Block phone number]"]:
			#Events.change_game_switch("BLOCK_alison_new_num", true)
		#
		#["Unknown", "Okay, maybe it's you."]:
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "alright, alright. just letting you know that my phone got stolen.")
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "someone contacted you, right?")
			#
			### TODO: Add branching route here.
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "Yeah, someone did. I thought it was you.", true)
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "aight, good to know. stay safe, okay?")
			#await get_tree().create_timer(1).timeout
			#Events.new_phone_message.emit("Unknown", "Alright, alright.", true)
			#Events.change_game_switch("PLAYER_is_aware", true)
#
		#["Unknown", "[Block her out of annoyance]"]:
			#Events.change_game_switch("BLOCK_alison_prank", true)
		
		["Alison", "Your mom."]:
			Events.change_game_switch("PLAYER_can_sleep", false)
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "What?")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "You're not getting anything from me.", true)
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Fuck you for stealing my friend's phone.", true)
			await get_tree().create_timer(1).timeout
			Events.change_game_switch("BLOCK_attacker_num", true)
		
		["Alison", "Fine, what about you?"]:
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Same. I'm just bored, Friender's currently down.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "You're really addicted, huh?", true)
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Well, what can I say? I'm quite famous there.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Just a micro-celeb, FYI.", true)
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Pssh. You're just jealous, girl.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Anyway, wanna check out a game? I'm really bored now.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "I guess I can. I got nothing to do anyway.", true)
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "Alright! Here's the link.")
			await get_tree().create_timer(1).timeout
			Events.new_phone_message.emit("Alison", "[url='www.surprise.com']Withering Tides Link[/url]")
			
#==============================================================================
# Message Attack Time.
#==============================================================================

func _hacker_attack_message(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "ATTACKER_begin":
		Events.game_switch_changed.disconnect(_hacker_attack_message)
		_friender_warning()
		
		## If player goofed around
		if Events.hack_checker():
			await get_tree().create_timer(5).timeout
			AudioManager.bgm_play("res://assets/audio/bgm/data_breach_1.ogg")
			Events.incoming_call.emit(1)
		## If player did not goof around.
		else:
			Events.change_game_switch("PLAYER_can_sleep", true)
			await get_tree().create_timer(5).timeout
			if Events.check_game_switch("PLAYER_is_aware"):
				AudioManager.bgm_play("res://assets/audio/bgm/data_breach.ogg")
			Events.new_phone_message.emit("Alison", "Yo, girl. Wassup?")
			await get_tree().create_timer(1).timeout
			if Events.check_game_switch("PLAYER_is_aware"):
				Events.new_phone_message.emit("Alison", "Your mom.", true, true)
			else:
				Events.new_phone_message.emit("Alison", "Fine, what about you?", true, true)

#===============================================================================
# START: Only if the player didn't get hacked.
#===============================================================================

func _hacker_spam_attack(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "BLOCK_attacker_num":
		await get_tree().create_timer(5).timeout
		Events.change_game_switch("HACKER_spam_attack", true)
		await get_tree().create_timer(10).timeout
		Events.change_game_switch("BLOCK_attacker_spam",true)
		Events.change_game_switch("END_force_gameover", true)

func _actual_spam_attack(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "HACKER_spam_attack":
		var rng = int(randf_range(0,4))
		while true:
			if Events.check_game_switch("BLOCK_attacker_spam"): break
			rng = int(randf_range(0,4))
			match rng:
				0: Events.new_phone_message.emit("??????", "YOU THINK YOU CAN PLAY ME LIKE THAT???")
				1: Events.new_phone_message.emit("??????", "SEE YOU SOON")
				2: Events.new_phone_message.emit("??????", "HAHAHAHAHAHAHHAHAHAHAHAHAHAHAHAHAHAHAHAHHAHAHAHAHAHAHAHAHAHAAHAHAHAHAHAHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA")
				_: Events.new_phone_message.emit("??????", "202.92.131.119")
			await get_tree().create_timer(0.1).timeout

func _friender_warning() -> void:
	Events.new_phone_message.emit("Friender", "Reminder to all users of Friender to be vigilant.")
	
#===============================================================================
# END: Only if the player didn't get hacked.
#===============================================================================
	
#===============================================================================
# START: If player still gets hacked
#===============================================================================
func _if_hacked_then_call_accepted(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "ATTACKER_call_rejected":
		for i in 5:
			await get_tree().create_timer(0.5).timeout
			Events.new_phone_message.emit("Alison", "[url='www.surprise.com']Withering Tides Link[/url]")
		await get_tree().create_timer(3).timeout
		Events.link_pressed.emit("www.surprise.com")
		
func _player_gets_hacked_like_an_idiot(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "PLAYER_bamboozle":
		Events.new_phone_message.emit("Alison", "I can't believe you fell for it!")
		await get_tree().create_timer(1).timeout
		for i in 20:
			await get_tree().create_timer(0.1).timeout
			Events.new_phone_message.emit("Alison", "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH")
			
		Events.phone_change_function.emit("off", false)
		Events.change_game_switch("NO_phone_sfx", true)
		Events.change_game_switch("END_force_gameover", true)
		
#===============================================================================
# END: If player still gets hacked
#===============================================================================

func _force_game_end(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "END_force_gameover":
		Events.pause_game_time(true)
		await get_tree().create_timer(5).timeout
		# Game ends.
		_hide_phone()
		AudioManager.bgs_stop()
		Events.change_map.emit("res://scenes/game_end.tscn", false)
		
