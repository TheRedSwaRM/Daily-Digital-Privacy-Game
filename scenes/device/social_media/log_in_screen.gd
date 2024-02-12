extends Control

signal sign_in_pressed
signal log_in_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_log_in_button_pressed():
	_login_deny()

func _on_sign_up_button_pressed():
	pass # Replace with function body.


func _on_log_in_name_gui_input(event):
	if Events.mouse_left_click(event):
		_login_deny()
	
func _on_log_in_password_gui_input(event):
	if Events.mouse_left_click(event):
		_login_deny()
	
func _login_deny():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "initial_login_attempt")
