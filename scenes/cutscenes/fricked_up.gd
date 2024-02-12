extends Control

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	Events.open_blinking_eye.emit()
	
	anim_player.play("fricked")
	await anim_player.animation_finished
	
	# Increase day counter.
	Events.day_counter += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
