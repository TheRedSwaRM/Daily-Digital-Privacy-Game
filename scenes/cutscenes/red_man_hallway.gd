extends Control

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("attack")
	await anim_player.animation_finished

	Events.change_map.emit("res://scenes/cutscenes/day_indicator.tscn", false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
