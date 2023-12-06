extends Control

enum State{
	IDLE,			# When the phone unflipped
	RUNNING			# If currently opened
}

@onready var animation_player = $AnimationPlayer
@onready var current_state = State.IDLE

signal unflip_phone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Flip or unflip
func _flip_phone(value: String):
	match value:
		"open":
			current_state = State.RUNNING
			animation_player.play("flip")
			await animation_player.animation_finished
		"close":
			current_state = State.IDLE
			animation_player.play("unflip")
			await animation_player.animation_finished
		_:
			print("Uh, hello? You forgot to state flipping?")



func _on_flipping_button_pressed():
	print("It's working.")
	match current_state:
		State.IDLE:
			_flip_phone("open")
		State.RUNNING:
			_flip_phone("close")
