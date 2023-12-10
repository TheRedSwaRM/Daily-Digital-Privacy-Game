extends Control

# WI-FI Vars
@onready var wifi_list = %WIFIList
@onready var wifi_settings_button = %WIFIButton
@onready var default_theme = preload("res://scenes/components/wifi_button.tres")
@onready var activated_theme = preload("res://scenes/components/wifi_button_activated.tres")
@onready var wifi_default_icon = preload("res://assets/images/device/wifi_icon.png")
@onready var wifi_activated_icon = preload("res://assets/images/device/wifi_icon_connected.png")

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

# %WIFIListger
#signal debug_connection_change(name: String)
#signal debug_location_change(value: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	fullscreen_option.button_pressed = GameSettings.fullscreen_value
	volume_slider.value = GameSettings.master_volume
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

	# Settings to track.
	Events.wifi_connection = current_connection
	Events.location = location_enabled

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


func _on_home_wifi_toggled(toggled_on):
	_play_accept()
	_wifi_list_change(%HomeWIFI, toggled_on)


func _on_ram_wifi_toggled(toggled_on):
	_play_accept()
	_wifi_list_change(%RamWIFI, toggled_on)


func _on_pldtwifi_toggled(toggled_on):
	_play_accept()
	_wifi_list_change(%PLDTWIFI, toggled_on)

# Automated function that reverts all buttons back to where they belong. Defaulted.
func _wifi_list_change(wifi_picked: Button, toggled: bool):
	for wifi_item in wifi_list.get_children():
		wifi_item.set_theme(default_theme)
		wifi_item.icon = wifi_default_icon
	
	if toggled:
		wifi_picked.set_theme(activated_theme)
		wifi_picked.icon = wifi_activated_icon
		wifi_settings_button.set_theme(activated_theme)
		wifi_settings_button.text = "CON"
		_change_current_connection(wifi_picked.text)
	else:
		wifi_picked.set_theme(default_theme)
		wifi_picked.icon = wifi_default_icon
		wifi_settings_button.set_theme(default_theme)
		wifi_settings_button.text = "None"
		_change_current_connection("none")

func _change_current_connection(value: String):
	current_connection = value
	Events.wifi_connection = current_connection
	#debug_connection_change.emit(value)

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

#===============================================================================
# Audios
#===============================================================================
func _play_accept():
	AudioManager.sfx_play(AudioManager.phone_accept_sfx)

func _play_back():
	AudioManager.sfx_play(AudioManager.phone_back_sfx)
