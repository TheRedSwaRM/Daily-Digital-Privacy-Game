extends Control

@onready var fullscreen_option = $GridContainer/FullScreenOption
@onready var volume_slider = $GridContainer/VolumeSlider

func _ready():
	fullscreen_option.button_pressed = GameSettings.fullscreen_value
	volume_slider.value = GameSettings.master_volume

func _on_full_screen_option_toggled(button_pressed):
	GameSettings.fullscreen_changed.emit(button_pressed)

func _on_volume_slider_value_changed(value):
	GameSettings.volume_changed.emit(value)

func _on_return_button_pressed():
	GameSettings.save_settings.emit()
	hide()
