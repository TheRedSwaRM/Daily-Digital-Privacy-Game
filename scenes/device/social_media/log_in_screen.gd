extends Control

signal signup_button_pressed
signal login_button_pressed

@onready var login_name = $LogInName
@onready var login_password = $LogInPassword

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func registration_successful(user_name: String, user_pass: String):
	login_name.text = user_name
	login_password.text = user_pass

func _on_log_in_button_pressed():
	if login_name.text == "" and login_password.text == "":
		_login_deny()
		return
	else:
		login_button_pressed.emit()

func _on_sign_up_button_pressed():
	if not (login_name.text == "" and login_password.text == ""):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "signed_up")
	else:	
		signup_button_pressed.emit()

func _on_log_in_name_gui_input(event):
	if Events.mouse_left_click(event):
		_login_deny()
	
func _on_log_in_password_gui_input(event):
	if Events.mouse_left_click(event):
		_login_deny()
	
func _login_deny():
	DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "initial_login_attempt")
