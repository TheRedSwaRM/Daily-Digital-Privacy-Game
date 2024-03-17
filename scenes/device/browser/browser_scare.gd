extends Control

@export var link_name: String
@export var tab_name: String
@export_file("*.png") var thumbnail

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_visibility_changed():
	## TODO: Change audio for this.
	if visible:
		Events.change_game_switch("PLAYER_can_sleep", false)
		AudioManager.sfx_play("res://assets/audio/sfx/monster.mp3")
		await get_tree().create_timer(3).timeout
		Events.phone_change_function.emit("off", false)
		Events.change_game_switch("END_force_gameover", true)
