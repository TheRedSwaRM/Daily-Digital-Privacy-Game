extends Control

@onready var fullscreen_option = $GridContainer/FullScreenOption
@onready var volume_slider = $GridContainer/VolumeSlider
@onready var music_slider = $GridContainer/MusicSlider
@onready var sfx_slider = $GridContainer/SFXSlider

func _ready():
	fullscreen_option.button_pressed = GameSettings.fullscreen_value
	volume_slider.value = GameSettings.master_volume
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

func _on_full_screen_option_toggled(button_pressed):
	GameSettings.fullscreen_changed.emit(button_pressed)

func _on_volume_slider_value_changed(value):
	GameSettings.master_volume_changed.emit(value)

func _on_music_slider_value_changed(value):
	GameSettings.music_volume_changed.emit(value)

func _on_sfx_slider_value_changed(value):
	GameSettings.sfx_volume_changed.emit(value)

func _on_return_button_pressed():
	GameSettings.save_settings.emit()
	hide()


