extends Control

@onready var fullscreen_option = $GridContainer/FullScreenOption
@onready var volume_slider = $GridContainer/VolumeSlider

func _ready():
	pass

func _on_full_screen_option_toggled(button_pressed):
	GameSettings.fullscreen_changed.emit(button_pressed)

func _on_volume_slider_value_changed(value):
	GameSettings.volume_changed.emit(value)

