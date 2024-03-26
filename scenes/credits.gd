extends Control

@onready var anim_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("credits")
	await anim_player.animation_finished
	Events.quit_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass