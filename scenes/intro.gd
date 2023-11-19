extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var skip_intro: bool

func _ready():
	if !skip_intro:
		anim_player.play("intro")
		await anim_player.animation_finished 
	get_tree().change_scene_to_file("res://scenes/main.tscn")
