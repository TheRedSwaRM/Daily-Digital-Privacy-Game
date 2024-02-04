extends Control

@export var skip_intro: bool
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():	
	if not skip_intro:
		AudioManager.sfx_play("res://assets/audio/sfx/phone_alarm.mp3")
		anim_player.play("intro")
		await anim_player.animation_finished
	
	#print("scenes")
	Events.activate_phone.emit()
	Events.new_phone_message.emit("Amelie", "Yo, bro. Just wanna do a quick heads up.")
	Events.new_phone_message.emit("Amelie", "There's like this new social media app. Check it out.")
	Events.phones_sounds = true
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn", false)
