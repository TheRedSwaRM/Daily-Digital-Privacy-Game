extends Control

@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.bgm_play("res://assets/audio/bgm/horror_droning.mp3")
	await get_tree().create_timer(2).timeout
	_do_blink()
	anim_player.play("creep_death")
	await anim_player.animation_finished
	Events.quit_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _do_blink():
	Events.do_full_blink.emit()
