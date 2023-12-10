#===============================================================================
# Least insane RPG Maker dickriding
#===============================================================================
extends Node

@onready var background_music = %BGM
@onready var sound_effect_queue = $SFX

@onready var phone_accept_sfx = "res://assets/audio/sfx/phone_accept.mp3"
@onready var phone_back_sfx = "res://assets/audio/sfx/phone_back.mp3"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	background_music.stream.loop = true
	background_music.play()

## Stops BGM, as expected.
func bgm_stop():
	background_music.stop()
	background_music.stream = null

func sfx_play(path: String):
	var sfx = AudioStreamPlayer.new()
	sound_effect_queue.add_child(sfx)
	sfx.finished.connect(_sfx_free.bind(sfx))
	sfx.bus = &"SFX"
	
	#print("Working")
	
	sfx.stream = load(path)
	sfx.play()
	
func _sfx_free(sfx_node):
	sfx_node.queue_free()
