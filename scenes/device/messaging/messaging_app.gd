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
func new_text_message(user_name: String, starting_text: String, is_player: bool = false, is_option: bool = false):
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
		new_list.add_new_text(starting_text, is_player, is_option)
	
	# If meron pala...
	# Sideways calling, so signal will handle the unread call. Easy.
	else:
		checked_contact.add_new_text(starting_text, is_player, is_option)
		
		# Move newest contact to above.
		contact_list.move_child(_find_in_contacts(user_name), 0)
		
func _starting_messages():
	new_text_message("Baster", "Rust time?")
	new_text_message("Baster", "Hell yeah!", true)
	new_text_message("Omier", "Noi!")
	new_text_message("Omier", "Yuh", true)
	new_text_message("Omier", "Yeah, I get it.", true, true)
	new_text_message("Omier", "I don't get it.", true, true)
	new_text_message("Omier", "Fuck off.", true, true)
	
	###### MOM ######
	new_text_message("Mom", "Hi honey, how are you doing?")
	new_text_message("Mom", "Hi mom, I'm doing fine, just letting time pass by while relaxing in my room.", true)
	new_text_message("Mom", "It's actually my sem break right now, so I think I can relax for some time before the next sem.", true)
	new_text_message("Mom", "That's good, are you eating often?")
	new_text_message("Mom", "Do you still have enough money?")
	new_text_message("Mom", "Yes mom, you don't have to worry about me too much, I can take care of myself here", true)
	new_text_message("Mom", "I know, you're just so far away and I can't see you often")
	new_text_message("Mom", "Just be careful around strangers, there are so many bad people out there")
	new_text_message("Mom", "Yes, I will", true)
	new_text_message("Mom", "I have friends here so I'm not lonely", true)
	new_text_message("Mom", "Friends are good, but still be careful.")
	new_text_message("Mom", "Don't trust anyone too easily.")
	new_text_message("Mom", "And don't stay out too late you need to get enough sleep")
	new_text_message("Mom", "Mom, you're kind of embarrassing me.", true)
	new_text_message("Mom", "I'm fine, really.", true)
	new_text_message("Mom", "At least I embarrassingly love you so much")
	new_text_message("Mom", "hahaha fine", true, true)
	new_text_message("Mom", "I love you too, Mom.", true)
	new_text_message("Mom", "Hahaha okay, okay, that's good")
	new_text_message("Mom", "I won't bother you anymore, just promise me you'll be safe and happy")
	new_text_message("Mom", "I promise, Mom, no need to worry too much about me", true)
	new_text_message("Mom", "Alright, I'll talk to you later")
	new_text_message("Mom", "Take care, honey")
	new_text_message("Mom", "👍")
	new_text_message("Mom", "Yes mom, I will", true)
	
	#################
	
	###### DAD ######

	new_text_message("Dad", "Nak, how's it going?")
	new_text_message("Dad", "It's doing good, dad", true)
	new_text_message("Dad", "It's actually my sem break right now", true)
	new_text_message("Dad", "So I have a lot of time to relax", true)
	new_text_message("Dad", "Okay good")
	new_text_message("Dad", "Mag-ingat ha")
	new_text_message("Dad", "Yes, dad", true)
	new_text_message("Dad", "👍")
	

	#################	

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
	
