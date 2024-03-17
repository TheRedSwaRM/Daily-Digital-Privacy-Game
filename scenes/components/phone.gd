extends Control

enum State{
	IDLE,			# When the phone unflipped
	RUNNING			# If currently opened
}

enum NavigationState {
	HOME,
	SOCIAL_MEDIA,
	MESSAGES,
	SETTINGS,
	QUIT
}

# Other stuff (please arrange later)
@onready var animation_player = $AnimationPlayer
@onready var the_phone_container = $PhoneContainer
@onready var phone_contents = $PhoneContainer/PhoneFunctions
@onready var phone_background = $PhoneContainer/ThePhone
@onready var current_state = State.IDLE

# Buttons and Stuff
@onready var quit_panel = $PhoneContainer/PhoneFunctions/QuitPanel
@onready var main_menu_buttons = $PhoneContainer/PhoneFunctions/MainMenuButtons

# Phone Background
@onready var main_menu_background = preload("res://assets/images/device/phone.png")
@onready var settings_background = preload("res://assets/images/device/phone_settings.png")
@onready var current_time_label = $PhoneContainer/PhoneFunctions/CurrentTime
@onready var blur_bg = $Blurry

# Settings
@onready var settings_instance = $PhoneContainer/PhoneFunctions/SettingsPanel
# Social Media
@onready var social_media = $PhoneContainer/PhoneFunctions/SocialMedia
@onready var social_media_button = $PhoneContainer/PhoneFunctions/MainMenuButtons/SocialMediaButton
# Messaging App
@onready var messaging_app = $PhoneContainer/PhoneFunctions/MessagingApp
# Browser App
@onready var browser_app = $PhoneContainer/PhoneFunctions/Browser
# Installer
@onready var installer_app = $PhoneContainer/PhoneFunctions/Installer
## Phone call instance, important
@onready var phone_call_instance = $PhoneContainer/PhoneFunctions/PhoneCall

# Current State
@onready var current_phone_location = NavigationState.HOME :
	get:
		return current_phone_location
	set(value):
		current_phone_location = value
		match current_phone_location:					# Debugging
			NavigationState.HOME:
				print("Home")
			NavigationState.SOCIAL_MEDIA:
				print("Social Media")
			NavigationState.SETTINGS:
				print("Settings")
			NavigationState.QUIT:
				print("Quit")

## Immediately installs the app to allow quicker debugging than usual.
@export var install_app_immediately: bool


signal flipping_phone(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Connect to Events
	Events.flip_phone.connect(_on_flipping_button_pressed)
	Events.ring_phone.connect(_phone_ringing)
	Events.force_phone_go_to.connect(_force_phone_goto)
	Events.game_switch_changed.connect(_should_app_be_installed)
	Events.incoming_call.connect(_phone_call)
	Events.phone_change_function.connect(_phone_change_function)
	#Events.change_time.connect(_change_time)
	
	_change_time(Events.game_time)
	
	# Allow the app to be installed immediately regardless of date.
	if install_app_immediately and OS.is_debug_build():
		Events.change_game_switch("app_installed", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Flip or unflip
func _flip_phone(value: String):
	var tween = get_tree().create_tween()
	tween.set_parallel()
	match value:
		"open":
			AudioManager.sfx_play("res://assets/audio/sfx/phone_open.mp3")
			flipping_phone.emit(true)
			current_state = State.RUNNING
			blur_bg.show()
			tween.tween_property(the_phone_container, "position", Vector2(56, 0), 0.1)
			tween.tween_method(set_shader_value, 0, 4, 0.1)
			await tween.finished
			#animation_player.play("flip")
			#await animation_player.animation_finished
		"close":
			AudioManager.sfx_play("res://assets/audio/sfx/phone_close.mp3")
			
			GameSettings.save_settings.emit() # Just in case
			
			flipping_phone.emit(false)
			current_state = State.IDLE
			tween.tween_property(the_phone_container, "position", Vector2(56, 134), 0.1)
			tween.tween_method(set_shader_value, 4, 0, 0.1)
			await tween.finished
			blur_bg.hide()
			#animation_player.play("unflip")
			#await animation_player.animation_finished
		_:
			print("Uh, hello? You forgot to state flipping?")

func set_shader_value(value: float):
	blur_bg.material.set_shader_parameter("shader_parameter/blur", value);

func _on_flipping_button_pressed():
	match current_state:
		State.IDLE:
			_flip_phone("open")
		State.RUNNING:
			_flip_phone("close")

	#phone_background.texture = settings_background

# Phone is ringing
func _phone_ringing():
	if current_state == State.IDLE:
		animation_player.play("ringing")
		await animation_player.animation_finished

func _on_phone_timer_frame_update_timeout():
	_change_time(Events.game_time)

func _change_time(current_time: float):
	var text_hour: String = ""
	var text_min: String = ""
	var hour: float = floor(current_time)
	var minutes: float = floor((current_time - hour) * 60)
	
	if hour < 10:
		text_hour = "0" + str(hour)
	else:
		text_hour = str(hour)
	
	if minutes < 10:
		text_min = "0" + str(minutes)
	else:
		text_min = str(minutes)
	
	current_time_label.text = text_hour + ":" + text_min

#===============================================================================
# SETTINGS FUNCTION
#===============================================================================

func _on_settings_button_pressed():
	_play_accept()
	current_phone_location = NavigationState.SETTINGS
	settings_instance.show()

func _on_return_button_pressed():
	_play_back()
	GameSettings.save_settings.emit()			# Save stuff
	current_phone_location = NavigationState.HOME

#===============================================================================
# QUIT FUNCTION
#===============================================================================

func _on_quit_button_pressed():
	_play_accept()
	current_phone_location = NavigationState.QUIT
	quit_panel.show()

func _on_quit_yes_pressed():
	_play_accept()
	Events.quit_game()

func _on_quit_no_pressed():
	_play_back()
	current_phone_location = NavigationState.HOME
	quit_panel.hide()

func _on_social_media_button_pressed():
	_play_accept()
	current_phone_location = NavigationState.SOCIAL_MEDIA
	social_media.show()

#===============================================================================
# MESSAGING FUNCTION
#===============================================================================

func _on_messaging_button_pressed():
	_play_accept()
	current_phone_location = NavigationState.MESSAGES
	messaging_app.show()

#===============================================================================
# Phone Call Moment
#===============================================================================

## If 0, then an Alison call. phone_call.gd checks for hacks instead.
## If 1, then it's the hacker calling. Same checks on phone_call

func _phone_call(value: int):
	## Game speed is now set to a minimum. Finale is now beginning.
	Events.game_speed = 1 

	match value:
		0:
			phone_call_instance.change_caller_name("Unknown")
		1:
			phone_call_instance.change_caller_name("Alison")
	animation_player.play("phone_call")

func _on_phone_call_call_accepted():
	if phone_call_instance.current_caller() == "Unknown":
		Events.change_game_switch("ALISON_call_accepted", true)
	if phone_call_instance.current_caller() == "Alison":
		Events.change_game_switch("ATTACKER_call_accepted", true)
	animation_player.stop()

func _on_phone_call_call_rejected():
	if phone_call_instance.current_caller() == "Unknown":
		Events.change_game_switch("ALISON_call_rejected", true)
	if phone_call_instance.current_caller() == "Alison":
		Events.change_game_switch("ATTACKER_call_rejected", true)
	Events.begin_attacker_phase()
	animation_player.stop()
	phone_call_instance.hide()

func _on_phone_call_call_ended():
	phone_call_instance.hide()
	Events.begin_attacker_phase() # The attacks begin.
	
	

#===============================================================================
# NAVIGATION FUNCTION
#===============================================================================

func _on_home_button_pressed():
	_play_back()
	social_media.hide()
	settings_instance.hide()
	messaging_app.hide()
	quit_panel.hide()
	browser_app.hide()
	
	# Given... like, literally.
	current_phone_location = NavigationState.HOME

# TODO: This is not the final state of this thing. This thing is going to be...
# MUCH, MUCH WORSE.
# NOTE: Nevermind, it's actually easy. Signals ftw!
func _on_back_button_pressed():
	_play_back()
	Events.back_button_pressed.emit()
	
	# At this rate, we have become bored.
	if quit_panel.visible:
		quit_panel.hide()

#===============================================================================
# BROWSER FUNCTION
#===============================================================================

func _on_browser_button_pressed():
	_play_accept()
	browser_app.show()

# Detects if app should be installed.
func _should_app_be_installed(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "app_installed":
		_play_accept()
		social_media_button.show()
		Events.game_switch_changed.disconnect(_should_app_be_installed)
		
#===============================================================================
# Audios
#===============================================================================
func _play_accept():
	AudioManager.sfx_play(AudioManager.phone_accept_sfx)

func _play_back():
	AudioManager.sfx_play(AudioManager.phone_back_sfx)

#===============================================================================
# Phone interaction
#===============================================================================
func _on_flipping_button_mouse_entered():
	if current_state == State.RUNNING:
		GameSettings.change_cursor_look(GameSettings.CursorLook.PHONE_DOWN)
	if current_state == State.IDLE:
		GameSettings.change_cursor_look(GameSettings.CursorLook.PHONE_UP)

func _on_flipping_button_mouse_exited():
	GameSettings.change_cursor_look()

func _force_phone_goto(module: String, subcomponent: String = ""):
	settings_instance.hide()
	messaging_app.hide()
	social_media.hide()
	browser_app.hide()
	installer_app.hide()
	
	match module:
		"Settings":
			pass
			
		"Messaging":
			messaging_app.show()
			messaging_app.contact_press_detected(subcomponent)
			
		"Social":
			pass
			
		# No need to open anything for this... for now.
		"Browser":
			browser_app.show()
			
		"Installer":
			installer_app.show()

func _phone_change_function(func_string: String, show_buttons: bool):
	match func_string:
		"active":
			phone_background.texture = load("res://assets/images/device/phone.png")
		"off":
			phone_background.texture = load("res://assets/images/device/phone_off.png")
		
	if show_buttons: phone_contents.show()
	else: phone_contents.hide()
	
	
