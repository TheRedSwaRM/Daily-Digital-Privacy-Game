extends Control

enum State{
	IDLE,			# When the phone unflipped
	RUNNING			# If currently opened
}

# Other stuff (please arrange later)
@onready var animation_player = $AnimationPlayer
@onready var phone_background = $PhoneContainer/ThePhone
@onready var current_state = State.IDLE

# Buttons and Stuff
@onready var quit_panel = $PhoneContainer/QuitPanel
@onready var main_menu_buttons = $PhoneContainer/MainMenuButtons

# Settings
@onready var settings_instance = $PhoneContainer/Settings

# Phone Background
@onready var main_menu_background = preload("res://assets/images/device/phone.png")
@onready var settings_background = preload("res://assets/images/device/phone_settings.png")

signal flipping_phone(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Flip or unflip
func _flip_phone(value: String):
	match value:
		"open":
			flipping_phone.emit(true)
			current_state = State.RUNNING
			animation_player.play("flip")
			await animation_player.animation_finished
		"close":
			GameSettings.save_settings.emit() # Just in case
			
			flipping_phone.emit(false)
			current_state = State.IDLE
			animation_player.play("unflip")
			await animation_player.animation_finished
		_:
			print("Uh, hello? You forgot to state flipping?")

func _on_flipping_button_pressed():
	print("It's working.")
	match current_state:
		State.IDLE:
			_flip_phone("open")
		State.RUNNING:
			_flip_phone("close")

	#phone_background.texture = settings_background

#===============================================================================
# SETTINGS FUNCTION
#===============================================================================

func _on_settings_button_pressed():
	settings_instance.show()

func _on_return_button_pressed():
	GameSettings.save_settings.emit()			# Save stuff
	#phone_background.texture = main_menu_background

#===============================================================================
# QUIT FUNCTION
#===============================================================================

func _on_quit_button_pressed():
	#main_menu_buttons.hide()
	quit_panel.show()

func _on_quit_yes_pressed():
	AudioManager.bgm_stop()
	Events.reset_all()
	get_tree().change_scene_to_file("res://scenes/title.tscn")
	#get_tree().quit()

func _on_quit_no_pressed():
	quit_panel.hide()
	#main_menu_buttons.show()


