extends Control

@onready var signup_name = $SignUpName
@onready var signup_number = $SignUpNumber
@onready var signup_password = $SignUpPassword

signal signup_complete(user_name: String, user_pass: String)
signal signup_return_button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_sign_up_button_pressed():
	var okay_checker: bool = false
	
	if not signup_name.text.length() >= 3:
		signup_name.text = ""
		signup_name.placeholder_text = "3 chars longer"
		okay_checker = true
	if signup_password.text.length() == 0:
		signup_password.text = ""
		signup_password.placeholder_text = "Password"
		okay_checker = true
		
	if okay_checker:
		return
	else:
		signup_complete.emit(signup_name.text, signup_password.text)
		signup_return_button.emit()
	
func _on_return_button_pressed():
	signup_return_button.emit()
