extends Control

@export var sender: String

@onready var user_name = $MessageHeader/MessageUser
@onready var message_list = $MessageScroller/MessageList

# Called when the node enters the scene tree for the first time.
func _ready():
	user_name.text = sender


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		user_name.text = sender
		

## Adds new post under MessageScroller
func add_new_post(text_message: String):
	var pre_text = preload("res://scenes/device/message_text_box.tscn")
	var new_text = pre_text.instantiate()
	
	new_text.post_text = text_message
	
	message_list.add_child(new_text)



func _on_debug_button_pressed():
	add_new_post("gaysex")
