extends Control

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	Events.open_blinking_eye.emit()
	
	anim_player.play("fricked")
	await anim_player.animation_finished
	Events.quit_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
