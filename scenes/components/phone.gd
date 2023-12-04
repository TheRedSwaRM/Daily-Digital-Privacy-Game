extends Control

@onready var animation_player = $AnimationPlayer

signal unflip_phone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Flip or unflip
func flip_phone(value: String):
	match value:
		"open":
			show()
			animation_player.play("flip")
			await animation_player.animation_finished
		"close":
			animation_player.play("unflip")
			await animation_player.animation_finished
			hide()
		_:
			print("Uh, hello? You forgot to state flipping?")


func _on_button_pressed():
	unflip_phone.emit()
