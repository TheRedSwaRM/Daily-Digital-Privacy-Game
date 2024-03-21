extends Control

@onready var anim_player = $AnimationPlayer
@onready var scare_container = $ScareContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("you_are_my_special")
	await anim_player.animation_finished
	scare_container.hide()
	await get_tree().create_timer(2).timeout 
	Events.quit_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
