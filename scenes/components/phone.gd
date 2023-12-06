extends Control

enum State{
	IDLE,			# When the phone unflipped
	RUNNING			# If currently opened
}

@onready var animation_player = $AnimationPlayer
@onready var phone_background = $PhoneContainer/ThePhone
@onready var current_state = State.IDLE

# Buttons and Stuff
@onready var main_menu_buttons = $PhoneContainer/MainMenuButtons
@onready var settings_menu = $PhoneContainer/SettingsMenu
@onready var panel_hack = $PhoneContainer/SettingsMenu/PanelWarningHack

# Settings Menu Button
@onready var fullscreen_option = %FullScreenOption
@onready var volume_slider = %VolumeSlider
@onready var location_warning = $PhoneContainer/SettingsMenu/LocationWarningPanel
@onready var location_button = $PhoneContainer/SettingsMenu/SettingsList/LocationHorz/LocationButton
@onready var wifi_panel = $PhoneContainer/SettingsMenu/WIFIPanel

# Phone Background
@onready var main_menu_background = preload("res://assets/images/device/phone.png")
@onready var settings_background = preload("res://assets/images/device/phone_settings.png")

signal flipping_phone(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	fullscreen_option.button_pressed = GameSettings.fullscreen_value
	volume_slider.value = GameSettings.master_volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _on_settings_button_pressed():
	main_menu_buttons.hide()
	settings_menu.show()
	#phone_background.texture = settings_background

#===============================================================================
# SETTINGS FUNCTION
#===============================================================================

func _on_full_screen_option_toggled(toggled_on):
	GameSettings.fullscreen_changed.emit(toggled_on)

func _on_volume_slider_value_changed(value):
	GameSettings.volume_changed.emit(value)

func _on_return_button_pressed():
	GameSettings.save_settings.emit()
	main_menu_buttons.show()
	settings_menu.hide()
	#phone_background.texture = main_menu_background

func _on_location_button_toggled(toggled_on):
	if !toggled_on:
		_panel_hack_toggle(true)
		location_warning.show()

func _on_loc_yes_button_pressed():
	location_button.button_pressed = false
	_panel_hack_toggle(false)
	location_warning.hide()

func _on_loc_no_button_pressed():
	location_button.button_pressed = true
	_panel_hack_toggle(false)
	location_warning.hide()

## Activates panel hack for convenience, when a panel is brought up to stop
## mouse events.
func _panel_hack_toggle(value: bool):
	if value:
		panel_hack.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		panel_hack.mouse_filter = Control.MOUSE_FILTER_IGNORE

#===============================================================================
# WIFI FUNCTION
#===============================================================================

func _on_wifi_button_pressed():
	_panel_hack_toggle(true)
	wifi_panel.show()
	
func _on_home_wifi_pressed():
	pass # Replace with function body.


func _on_ram_wifi_pressed():
	pass # Replace with function body.


func _on_pldtwifi_pressed():
	pass # Replace with function body.

## Literally goofy. Please optimize.
func _on_panel_warning_hack_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and (panel_hack.mouse_filter == Control.MOUSE_FILTER_STOP):
		print("Vibe check.")
		_panel_hack_toggle(false)	# Expected, since this only happens when hack panel is on.
		if location_warning.visible:
			location_button.button_pressed = true
			location_warning.hide()
		if wifi_panel.visible:
			wifi_panel.hide()
