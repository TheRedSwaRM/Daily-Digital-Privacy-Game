extends Control

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	Events.open_blinking_eye.emit()
	
	anim_player.play("fricked")
	await anim_player.animation_finished
	
	Events.change_map.emit("res://scenes/cutscenes/day_indicator.tscn", false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
