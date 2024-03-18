extends Control

signal call_accepted
signal call_rejected
signal call_ended

@onready var caller_name = $CallerName
@onready var timer_tick = $Timer
@onready var call_time = $OngoingCall/CallTime

@onready var incoming_layer = $IncomingCall
@onready var outgoing_layer = $OngoingCall

@onready var good_call = "res://assets/audio/cutscene/not_much_bitcrushed.wav"
@onready var bad_call = "res://assets/audio/cutscene/violated_new_bitcrushed.wav"
## Change this later.
@onready var worst_call = "res://assets/audio/cutscene/violated_new_bitcrushed.wav"
@onready var skip_call = "res://assets/audio/sfx/new_phone_ring.mp3"
@onready var horror_droning = "res://assets/audio/cutscene/horror_droning_heartbeat.wav"
@onready var end_call_button = $OngoingCall/EndCall

@export var skip_the_calls: bool = false 

var end_the_game = false
var internal_time = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	AudioManager.is_call_finished.connect(_phone_call_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_caller_name(call_name: String):
	caller_name.text = call_name

func current_caller():
	return caller_name.text

func reset_state():
	#Events.game_speed = 20
	caller_name.text = "Unknown"
	call_time.text = "00:00"
	timer_tick.stop()
	incoming_layer.show()
	outgoing_layer.hide()
	internal_time = 0

func _on_phone_accept_pressed():
	#Events.game_speed = 1
	call_accepted.emit()
	timer_tick.start()
	
	match caller_name.text:
		"Unknown":
			## Checks for hacks.
			var hack_check: bool = false
			
			## Kept this way so taht 
			hack_check = Events.hack_checker()
			
			if hack_check:
				print("Walahi, we're finished.")
				_activate_call(bad_call)
				AudioManager.horror_play(horror_droning)
			else: 
				print("Good call fr.")
				_activate_call(good_call)
				
			Events.change_game_switch("PLAYER_is_aware", true)
		"Alison":
			_activate_call(worst_call)
			Events.change_game_switch("ATTACKER_irl_begin", true)
			end_the_game = true
		_:
			_activate_call(good_call)
			
	incoming_layer.hide()
	outgoing_layer.show()

func _on_phone_reject_pressed():
	call_rejected.emit()
	reset_state()

func _phone_call_end():
	if end_the_game: Events.change_game_switch("END_force_gameover", true)
	reset_state()
	AudioManager.horror_stop()
	call_ended.emit()
	
func _activate_call(call_file: String):
	if not skip_the_calls and OS.is_debug_build():
		AudioManager.phone_call(call_file)
	else: 
		AudioManager.phone_call(skip_call)

func _on_timer_timeout():
	internal_time += 1
	var seconds = internal_time % 60
	var minutes = (internal_time / 60) % 60
	
	call_time.text = "%02d:%02d" % [minutes, seconds]
	
	## Additional effects. This is a quick hack btw, there should be a better fix.
	if seconds > 30 and seconds < 55\
	and caller_name.text == "Unknown" \
	and Events.hack_checker():
		AudioManager.dizzy_changer(true)
	else:
		AudioManager.dizzy_changer(false)
	
	
func _on_end_call_pressed():
	pass # Replace with function body.
