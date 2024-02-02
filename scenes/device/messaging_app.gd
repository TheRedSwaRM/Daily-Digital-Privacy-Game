extends Control

#--text: #050315;
#--background: #fbfbfe;
#--primary: #2f27ce;
#--secondary: #dedcff;
#--accent: #433bff;



@onready var contact_list = $MessageContacts/ContactList

# Needed to parse through for sideways signali(si)ng.
@onready var message_lists = $MessageLists

@onready var back_button = $Header/BackButton
@onready var ui_header = $Header/UIHeader

var current_message_list: ScrollContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_debug_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Self-explanatory nightmare. Dear Lord, help us ALL.
## INITIAL MESSAGE IS VITAL. REALLY, REALLY VITAL!
## I MEAN, WE CAN HAVE BLANK BUT IT'S WEIRD.
func add_new_contact(user_name: String, starting_text: String):
	var pre_contact = preload("res://scenes/device/message_direct.tscn")
	var pre_list = preload("res://scenes/device/message_user_texts.tscn")
	var new_contact = pre_contact.instantiate()
	var new_list = pre_list.instantiate()
	
	new_contact.sender = user_name
	new_contact.name = user_name
	
	new_list.name = user_name
	
	# Adding signal before anything else. 
	# NOTE: Not safe! Like, legit. We are expecting a signal!
	new_contact.contact_pressed.connect(_contact_press_detected)
		
	# And then add it to the parent Contact List.
	contact_list.add_child(new_contact)
	message_lists.add_child(new_list)

	# Adding first text via function.
	# NOTE: Again, not fucking safe! We know the function but holy shit!
	new_list.add_new_text(starting_text)

func _on_debug_pressed():
	add_new_contact("ambaturam", "hello")
	add_new_contact("ambatudie", "hi")
	add_new_contact("ambastin", "ambatublow")

## Guess why we're doing this because the last time we did, it was NOT pretty!
## NOTE: Don't forget possible errors! Even though we're not expecting THAT!
func _contact_press_detected(user_name: String):
	# Iterate
	for user_message_list in message_lists.get_children():
		# Then do and break
		if user_message_list.name == user_name:
			print("Found " + user_name)
			current_message_list = user_message_list
			back_button.show()
			current_message_list.show()
			contact_list.hide()
			break


func _on_back_button_pressed():
	assert(current_message_list != null, "Woops! Non-existent! Too bad!")
	back_button.hide()
	current_message_list.hide()
	contact_list.show()
