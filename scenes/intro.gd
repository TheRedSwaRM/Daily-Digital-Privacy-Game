extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if !OS.is_debug_build():
		anim_player.play("intro")
		await anim_player.animation_finished 
	get_tree().change_scene_to_file("res://scenes/main.tscn")
