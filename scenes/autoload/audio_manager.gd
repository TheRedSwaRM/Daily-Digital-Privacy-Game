#===============================================================================
# Least insane RPG Maker dickriding
#===============================================================================
extends Node

@onready var background_music = %BGM

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Plays BGM. Replaces if BGM currently playing.
func bgm_play(path: String):
	var new_music = load(path)
	
	# Check if BGM is the same
	if background_music.stream == new_music:
		print("The same music.")
		return
	
	# Switches BGM.
	if background_music.playing:
		bgm_stop()
	
	background_music.stream = load(path)
	background_music.play()

## Stops BGM, as expected.
func bgm_stop():
	background_music.stop()
	background_music.stream = null
