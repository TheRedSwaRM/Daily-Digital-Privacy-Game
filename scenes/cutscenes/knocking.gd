extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	await get_tree().create_timer(1).timeout
	Events.open_blinking_eye.emit()
	
	anim_player.play("knocking")
	await anim_player.animation_finished
	
	#print("scenes")
	Events.activate_phone.emit()
	Events.change_map.emit("res://scenes/areas/bedroom_laptop.tscn")
