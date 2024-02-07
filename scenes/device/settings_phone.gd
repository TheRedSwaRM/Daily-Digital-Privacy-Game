extends Control

# WI-FI Vars
@onready var wifi_list = %WIFIList
@onready var wifi_settings_button = %WIFIButton
@onready var wifi_pass_panel = %WIFIPassPanel
@onready var default_theme = preload("res://scenes/components/wifi_button.tres")
@onready var activated_theme = preload("res://scenes/components/wifi_button_activated.tres")
@onready var wifi_default_icon = preload("res://assets/images/device/wifi_icon.png")
@onready var wifi_activated_icon = preload("res://assets/images/device/wifi_icon_connected.png")
@onready var wifi_haspass_icon = preload("res://assets/images/device/wifi_haspass_icon.png")

@onready var panel_hack = $PanelWarningHack
@onready var wifi_panel = $WIFIPanel

# Wifi and Location
@onready var current_connection: String = ""
@onready var location_enabled: bool = true
@onready var location_warning = $LocationWarningPanel
@onready var location_button = $SettingsList/LocationHorz/LocationButton

# Settings
@onready var fullscreen_option = %FullScreenOption
@onready var volume_slider = %VolumeSlider
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider

# Initially empty because that's first assumption.
# Also to avoid future issues of adding stuff. Genius.
var wifi_access: Dictionary
var needed_password: String
var pass_connecting_wifi: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	
	fullscreen_option.button_pressed = GameSettings.fullscreen_value
	volume_slider.value = GameSettings.master_volume
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

	# Settings to track.
	Events.wifi_connection = current_connection
	Events.location = location_enabled
	Events.back_button_pressed.connect(_is_back_button_pressed)

	# And then finally, for the WI-FU Panel.
	# For WI-FIs with passwords ONLY.
	for children in %WIFIList.get_children():
		# Hack time. Only passwords with the following HAVE that icon!
		if children.icon.resource_path == wifi_haspass_icon.resource_path:
			wifi_access[children.name] = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Activates panel hack for convenience, when a panel is brought up to stop
## mouse events.
func _panel_hack_toggle(value: bool):
	if value:
		panel_hack.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		panel_hack.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_wifi_button_pressed():
	_play_accept()
	_panel_hack_toggle(true)
	wifi_panel.show()

#===============================================================================
# BEGIN: LOCATION
#===============================================================================

func _on_location_button_toggled(toggled_on):
	if !toggled_on:
		_play_accept()
		_panel_hack_toggle(true)
		location_warning.show()
	else:
		_play_accept()
		_change_location_value(true)
		#debug_location_change.emit(true)		# For debugging

func _on_loc_yes_button_pressed():
	_play_accept()
	_change_location_value(false)
	location_button.button_pressed = false
	#debug_location_change.emit(false)			# For debugging
	_panel_hack_toggle(false)
	location_warning.hide()


func _on_loc_no_button_pressed():
	_play_back()
	location_button.button_pressed = true
	#debug_location_change.emit(true)			# For debugging
	_panel_hack_toggle(false)
	location_warning.hide()

func _change_location_value(value: bool):
	location_enabled = value
	Events.location = location_enabled

#===============================================================================
# END: LOCATION
#===============================================================================

func _on_full_screen_option_toggled(toggled_on):
	_play_accept()
	GameSettings.fullscreen_changed.emit(toggled_on)


func _on_volume_slider_value_changed(value):
	GameSettings.master_volume_changed.emit(value)


func _on_music_slider_value_changed(value):
	GameSettings.music_volume_changed.emit(value)


func _on_sfx_slider_value_changed(value):
	GameSettings.sfx_volume_changed.emit(value)

#===============================================================================
# START: WI-FI
#===============================================================================

func _on_home_wifi_toggled(toggled_on):
	_play_accept()
	if not wifi_access[%HomeWIFI.name]:
		pass_connecting_wifi = %HomeWIFI
		needed_password = "homealone"
		wifi_pass_panel.show()
	else:
		_wifi_list_change(%HomeWIFI, toggled_on)

func _on_ram_wifi_toggled(toggled_on):
	_play_accept()
	_wifi_list_change(%RamWIFI, toggled_on)

func _on_pldtwifi_toggled(toggled_on):
	_play_accept()
	if not wifi_access[%PLDTWIFI.name]:
		pass_connecting_wifi = %PLDTWIFI
		needed_password = "howdidyouknow"
		wifi_pass_panel.show()
	else:
		_wifi_list_change(%PLDTWIFI, toggled_on)

# Automated function that reverts all buttons back to where they belong. Defaulted.
func _wifi_list_change(wifi_picked: Button, toggled: bool):
	for wifi_item in wifi_list.get_children():
		wifi_item.set_theme(default_theme)
		if wifi_access.has(wifi_item.name):
			wifi_item.icon = wifi_haspass_icon
		else:
			wifi_item.icon = wifi_default_icon
	
	if toggled:
		wifi_picked.set_theme(activated_theme)
		wifi_picked.icon = wifi_activated_icon
		wifi_settings_button.set_theme(activated_theme)
		wifi_settings_button.text = "CON"
		_change_current_connection(wifi_picked.text)
	else:
		wifi_picked.set_theme(default_theme)
		if wifi_access.has(wifi_picked.name):
			wifi_picked.icon = wifi_haspass_icon
		else:
			wifi_picked.icon = wifi_default_icon
		#wifi_picked.icon = wifi_default_icon
		wifi_settings_button.set_theme(default_theme)
		wifi_settings_button.text = "None"
		_change_current_connection("none")

func _change_current_connection(value: String):
	current_connection = value
	Events.wifi_connection = current_connection
	#debug_connection_change.emit(value)

## When the password is given.
func _on_password_key_text_submitted(new_text):
	# Under the assumption that the password is set.
	if needed_password == new_text:
		_wifi_list_change(pass_connecting_wifi, true)
		wifi_access[pass_connecting_wifi.name] = true
		_play_accept()
	else:
		_play_back()
	# Clean after attempt.
	_wifi_pass_panel_handling()
	wifi_pass_panel.hide()
	
# Helper function so that... well, no copy-pasting.
func _wifi_pass_panel_handling():
	needed_password = ""
	pass_connecting_wifi = null
	%PasswordKey.text = ""

#===============================================================================
# END: WI-FI
#===============================================================================

func _on_return_button_pressed():
	_play_back()
	GameSettings.save_settings.emit()
	hide()

func _on_panel_warning_hack_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and (panel_hack.mouse_filter == Control.MOUSE_FILTER_STOP):
		#print("Vibe check.")
		_play_back()
		_panel_hack_toggle(false)	# Expected, since this only happens when hack panel is on.
		if location_warning.visible:
			location_button.button_pressed = true
			location_warning.hide()
		if wifi_panel.visible:
			wifi_panel.hide()

# Special function that no other function WILL INTERACT WITH.
# Purposefully connected with the Event.back_button_pressed only.
# Checks top to bottom to see which panel is active. Really intuitive.
func _is_back_button_pressed():
	if not visible: 
		print("Settings already not visible.")
		return
	# for possible cases that it is open... HANDLE THIS SOON
	if wifi_pass_panel.visible:
		_wifi_pass_panel_handling()
		wifi_pass_panel.hide()
		return
	_panel_hack_toggle(false)
	if wifi_panel.visible:
		wifi_panel.hide()
		return
	if location_warning.visible:
		location_button.button_pressed = true
		location_warning.hide()
		return
	
	# If there are no available windows to begin with.
	hide()
	
#===============================================================================
# Audios
#===============================================================================
func _play_accept():
	AudioManager.sfx_play(AudioManager.phone_accept_sfx)

func _play_back():
	AudioManager.sfx_play(AudioManager.phone_back_sfx)



