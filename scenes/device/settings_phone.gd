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
var connecting_wifi_button: Button

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
		if children.name == "DormWifi":
			Events.new_phone_message.emit("DormMngr", children.wifi_password)
			Events.new_phone_message.emit("DormMngr", "The password for the month is the following:")
			
		# Hack time. Only passwords with the following HAVE that icon!
		children.wifi_button_pressed.connect(_wifi_button_pressed)
	

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

func _wifi_button_pressed(ref_node: Button, toggled: bool):
	_play_accept()
	# For wifis with passwords
	if ref_node.wifi_password != "":
		if ref_node.has_access:
			_wifi_list_change(ref_node, toggled)
		else:
			connecting_wifi_button = ref_node
			wifi_pass_panel.show()
	else:
		_wifi_list_change(ref_node, toggled)

# Automated function that reverts all buttons back to where they belong. Defaulted.
func _wifi_list_change(wifi_picked: Button, toggled: bool):
	wifi_picked.set_default_icon()
	if toggled:
		wifi_settings_button.set_theme(activated_theme)
		wifi_settings_button.text = "CON"
		_change_current_connection(wifi_picked.name)
	else:
		wifi_settings_button.set_theme(activated_theme)
		wifi_settings_button.text = "NONE"
		_change_current_connection("none")
		

func _change_current_connection(value: String):
	current_connection = value
	Events.wifi_connection = current_connection

## When the password is given.
func _on_password_key_text_submitted(new_text):
	# Under the assumption that the password is set.
	if connecting_wifi_button.wifi_password == new_text:
		print("Access granted")
		connecting_wifi_button.has_access = true
		_wifi_list_change(connecting_wifi_button, true)
		_play_accept()
	else:
		connecting_wifi_button.button_pressed = false
		#connecting_wifi_button.set_default_icon()
		_play_back()
	
	_wifi_pass_panel_handling()
	wifi_pass_panel.hide()

func _wifi_pass_panel_handling():
	connecting_wifi_button = null
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
	GameSettings.save_settings.emit()
	hide()
	
#===============================================================================
# Audios
#===============================================================================
func _play_accept():
	AudioManager.sfx_play(AudioManager.phone_accept_sfx)

func _play_back():
	AudioManager.sfx_play(AudioManager.phone_back_sfx)



