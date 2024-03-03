extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():	
	AudioManager.sfx_play("res://assets/audio/sfx/phone_alarm.mp3")
	anim_player.play("intro")
	await anim_player.animation_finished
	
	Events.activate_phone.emit()
	Events.phones_sounds = true
	
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn", false)
