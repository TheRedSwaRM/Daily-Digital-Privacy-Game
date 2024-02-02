extends Control

#--text: #050315;
#--background: #fbfbfe;
#--primary: #2f27ce;
#--secondary: #dedcff;
#--accent: #433bff;

@onready var contact_list = $MessageLayouts/ContactList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Self-explanatory nightmare. Dear Lord, help us ALL.
func add_new_contact(user_name: String):
	var pre_text = preload("res://scenes/device/message_direct.tscn")
	var new_text = pre_text.instantiate()
	
	new_text.sender = user_name
	new_text.name = user_name
	
	contact_list.add_child(new_text)

func _on_debug_pressed():
	add_new_contact("ambaturam")
	add_new_contact("ambatudie")
