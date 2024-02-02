extends Control

signal contact_pressed(user_name: String)

@export var sender: String

@onready var user_name = $MessageHeader/MessageUser

@onready var message_header = $MessageHeader
@onready var unread_indicator = $MessageHeader/MessageNew

# Called when the node enters the scene tree for the first time.
func _ready():
	user_name.text = sender

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		user_name.text = sender
		
## If detected, switch to
func _on_message_header_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if unread_indicator.visible: unread_indicator.hide()
		contact_pressed.emit(sender)

## Makes unread_indicator visible again to alert user.
func new_text_unread():
	unread_indicator.show()
