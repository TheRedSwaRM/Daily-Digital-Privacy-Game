extends Control

@export_category("Attacker Look")
@export var attacker_texture: Texture2D
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	if Events.check_game_switch("ATTACKER_irl_begin"):
		var rng = randf()
		if rng > 0.4:
			show()
			timer.start()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	Events.do_full_blink.emit()
	await get_tree().create_timer(0.1).timeout
	hide()
