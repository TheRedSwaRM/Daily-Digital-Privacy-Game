extends Control

signal call_accepted
signal call_rejected

@onready var caller_name = $CallerName
@onready var timer_tick = $Timer
@onready var call_time = $OngoingCall/CallTime

@onready var incoming_layer = $IncomingCall
@onready var outgoing_layer = $OngoingCall

var internal_time = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	AudioManager.is_call_finished.connect(_phone_call_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_caller_name(call_name: String):
	caller_name.text = call_name

func current_caller():
	return caller_name.text

func reset_state():
	pass

func _on_phone_accept_pressed():
	call_accepted.emit()
	timer_tick.start()
	incoming_layer.hide()
	outgoing_layer.show()

func _on_phone_reject_pressed():
	call_rejected.emit()

func _phone_call_end():
	timer_tick.stop()

func _on_timer_timeout():
	internal_time += 1
	var seconds = internal_time % 60
	var minutes = (internal_time / 60) % 60
	
	call_time.text = "%02d:%02d" % [minutes, seconds]
	
