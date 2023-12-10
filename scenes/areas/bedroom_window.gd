extends Node2D

@onready var cloud_animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	cloud_animation.play("clouds")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pillow_input_detected():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/sleeping_time.dialogue"))
