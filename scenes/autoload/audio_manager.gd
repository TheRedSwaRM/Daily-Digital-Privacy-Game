#===============================================================================
# Least insane RPG Maker dickriding
#===============================================================================
extends Node

signal is_call_finished

@onready var background_music = %BGM
@onready var call_stream = %PhoneCall
@onready var sound_effect_queue = $SFX

@onready var phone_accept_sfx = "res://assets/audio/sfx/phone_accept.mp3"
@onready var phone_back_sfx = "res://assets/audio/sfx/phone_back.mp3"
@onready var phone_new_message_sfx = "res://assets/audio/sfx/phone_new_message.mp3"

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

## Makes phone call
func phone_call(path: String):
	call_stream.stream = load(path)
	call_stream.play()

## Stops BGM, as expected.
func bgm_stop():
	background_music.stop()
	background_music.stream = null

func sfx_play(path: String):
	# Check first if it's allowed to play the phone sounds. Better to stop it
	# here than ANYWHERE ELSE.
	if not Events.phones_sounds:
		match path:
			phone_accept_sfx: return
			phone_back_sfx: return
			phone_new_message_sfx: return
	
	var sfx = AudioStreamPlayer.new()
	sound_effect_queue.add_child(sfx)
	sfx.finished.connect(_sfx_free.bind(sfx))
	sfx.bus = &"SFX"
	
	#print("Working")
	
	sfx.stream = load(path)
	sfx.play()
	
func _sfx_free(sfx_node):
	sfx_node.queue_free()

func _on_phone_call_finished():
	is_call_finished.emit()
