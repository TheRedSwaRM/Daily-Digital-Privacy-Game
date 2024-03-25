extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var skip_to_day_three: bool

func _ready():	
	AudioManager.sfx_play("res://assets/audio/sfx/phone_alarm.mp3")
	anim_player.play("intro")
	await anim_player.animation_finished
	
	Events.activate_phone.emit()
	Events.phones_sounds = true
	
	if skip_to_day_three and OS.is_debug_build():
		print("Skipping to Day 3")
		Events.change_game_switch("WARNING_posted_with_location", true)
		Events.day_counter = 3
	
	# We'll make the day faster.
	if Events.day_counter == 3:
		Events.change_game_switch("deactivate_social_media", true)
		Events.game_speed = 20
	
	Events.pause_game_time(false)
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn", false)
