extends Control

@export var skip_intro: bool
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():	
	if not skip_intro or not Events.day_counter == 1:
		AudioManager.sfx_play("res://assets/audio/sfx/phone_alarm.mp3")
		anim_player.play("intro")
		await anim_player.animation_finished
	
	Events.activate_phone.emit()
	Events.phones_sounds = true
	
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn", false)
