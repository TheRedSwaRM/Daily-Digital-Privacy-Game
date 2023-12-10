extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var skip_intro: bool
@export_file var path_to_nowhere

func _ready():
	if !skip_intro:
		anim_player.play("intro")
		await anim_player.animation_finished
	#print("scenes")
	Events.activate_phone.emit()
	Events.change_map.emit(path_to_nowhere)
