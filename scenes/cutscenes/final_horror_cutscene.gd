extends Control

@onready var animation_player = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")
	await animation_player.animation.finished
	
	Events.quit_game()
