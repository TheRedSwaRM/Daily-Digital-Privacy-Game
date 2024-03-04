extends Control

signal call_accepted
signal call_rejected

@onready var caller_name = $CallerName
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_phone_accept_pressed():
	if caller_name.text == "Unknown":
		Events.change_game_switch("ALISON_call_accepted", true)
	if caller_name.text == "Alison":
		Events.change_game_switch("ATTACKER_call_accepted", true)

func _on_phone_reject_pressed():
	if caller_name.text == "Unknown":
		Events.change_game_switch("ALISON_call_rejected", true)
	if caller_name.text == "Alison":
		Events.change_game_switch("ATTACKER_call_rejected", true)
	hide()
