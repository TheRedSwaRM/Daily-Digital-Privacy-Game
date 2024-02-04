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
@onready var phone_background = $PhoneContainer/ThePhone
@onready var current_state = State.IDLE

# Buttons and Stuff
@onready var quit_panel = $PhoneContainer/QuitPanel
@onready var main_menu_buttons = $PhoneContainer/MainMenuButtons

# Settings
@onready var settings_instance = $PhoneContainer/SettingsPanel

# Phone Background
@onready var main_menu_background = preload("res://assets/images/device/phone.png")
@onready var settings_background = preload("res://assets/images/device/phone_settings.png")

# Social Media
@onready var social_media = $PhoneContainer/SocialMedia

# Messaging App
@onready var messaging_app = $PhoneContainer/MessagingApp

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

signal flipping_phone(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.flip_phone.connect(_on_flipping_button_pressed)
	Events.ring_phone.connect(_phone_ringing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Flip or unflip
func _flip_phone(value: String):
	match value:
		"open":
			AudioManager.sfx_play("res://assets/audio/sfx/phone_open.mp3")
			flipping_phone.emit(true)
			current_state = State.RUNNING
			animation_player.play("flip")
			await animation_player.animation_finished
		"close":
			AudioManager.sfx_play("res://assets/audio/sfx/phone_close.mp3")
			
			GameSettings.save_settings.emit() # Just in case
			
			flipping_phone.emit(false)
			current_state = State.IDLE
			animation_player.play("unflip")
			await animation_player.animation_finished
		_:
			print("Uh, hello? You forgot to state flipping?")

func _on_flipping_button_pressed():
	match current_state:
		State.IDLE:
			_flip_phone("open")
		State.RUNNING:
			_flip_phone("close")

	#phone_background.texture = settings_background

# Phone is ringing
func _phone_ringing():
	animation_player.play("ringing")
	await animation_player.animation_finished

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
	#AudioManager.bgm_stop()
	#Events.reset_all()
	#get_tree().change_scene_to_file("res://scenes/title.tscn")

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
# NAVIGATION FUNCTION
#===============================================================================

func _on_home_button_pressed():
	_play_back()
	match current_phone_location:
		NavigationState.HOME:
			return
		NavigationState.SOCIAL_MEDIA:
			social_media.hide()
		NavigationState.SETTINGS:
			settings_instance.hide()
		NavigationState.MESSAGES:
			messaging_app.hide()
		NavigationState.QUIT:
			quit_panel.hide()
	
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
	
	#match current_phone_location:
		#NavigationState.HOME:
			#return
		#NavigationState.SOCIAL_MEDIA:
			#social_media.hide()
		#NavigationState.SETTINGS:
			#settings_instance.hide()
		#NavigationState.MESSAGES:
			#messaging_app.hide()
		#NavigationState.QUIT:
			#quit_panel.hide()
	#
	## Given... like, literally.
	#current_phone_location = NavigationState.HOME


#===============================================================================
# Audios
#===============================================================================
func _play_accept():
	AudioManager.sfx_play(AudioManager.phone_accept_sfx)

func _play_back():
	AudioManager.sfx_play(AudioManager.phone_back_sfx)


