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
	Events.new_phone_message.connect(new_text_message)
	Events.back_button_pressed.connect(_on_back_button_pressed)
	_starting_messages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Self-explanatory nightmare. Dear Lord, help us ALL.
## INITIAL MESSAGE IS VITAL. REALLY, REALLY VITAL!
## I MEAN, WE CAN HAVE BLANK BUT IT'S WEIRD.
func new_text_message(user_name: String, starting_text: String, is_player: bool = false):
	var checked_contact = _if_in_message_lists(user_name)
	
	# If null, creates a new message and contact list
	if checked_contact == null:
		var pre_contact = preload("res://scenes/device/messaging/message_direct.tscn")
		var pre_list = preload("res://scenes/device/messaging/message_user_texts.tscn")
		var new_contact = pre_contact.instantiate()
		var new_list = pre_list.instantiate()
		
		new_contact.sender = user_name
		new_contact.name = user_name
		
		new_list.name = user_name
		
		# Adding signal before anything else. 
		# NOTE: Not safe! Like, legit. We are expecting a signal!
		new_contact.contact_pressed.connect(_contact_press_detected)
		# NOTE: Don't forget the unread signal to for sideways between contact
		# 		and list!
		new_list.new_text_added.connect(new_contact.new_text_unread)
		
		# And then add it to the parent Contact List.
		contact_list.add_child(new_contact)
		message_lists.add_child(new_list)

		# Also move newest contact above.
		contact_list.move_child(new_contact, 0)
		
		# Adding first text via function.
		# NOTE: Again, not fucking safe! We know the function but holy shit!
		new_list.add_new_text(starting_text, is_player)
	
	# If meron pala...
	# Sideways calling, so signal will handle the unread call. Easy.
	else:
		checked_contact.add_new_text(starting_text, is_player)
		
		# Move newest contact to above.
		contact_list.move_child(_find_in_contacts(user_name), 0)
		
func _starting_messages():
	new_text_message("Baster", "Rust time?")
	new_text_message("Baster", "Hell yeah!", true)
	new_text_message("Omier", "Noi!")
	new_text_message("Omier", "Yuh", true)

## Guess why we're doing this because the last time we did, it was NOT pretty!
## NOTE: Don't forget possible errors! Even though we're not expecting THAT!
func _contact_press_detected(user_name: String):
	# Iterate
	for user_message_list in message_lists.get_children():
		# Then do and break
		if user_message_list.name == user_name:
			print("Found " + user_name)
			current_message_list = user_message_list
			ui_header.text = user_name
			back_button.show()
			current_message_list.show()
			contact_list.hide()
			break

## Checks if the following is in contacts. Checks on MessageLists instead so
## that it would be an immediately addition to the text.
func _if_in_message_lists(user_name: String):
	for user_contacts in message_lists.get_children():
		if user_contacts.name == user_name: return user_contacts
	return null

func _find_in_contacts(user_name: String):
	for user_contacts in contact_list.get_children():
		if user_contacts.name == user_name: return user_contacts
	return null

## Unlike settings, might be volatile. But ya know, we're kinda gunning it here.
func _on_back_button_pressed():
	if not visible:
		print("Messaging already not visible.")
		return
	
	if current_message_list != null:
		ui_header.text = "Messaging"
		back_button.hide()
		current_message_list.hide()
		contact_list.show()
		
		current_message_list = null
		return
	
	# If no other stuff are open.
	hide()
	
