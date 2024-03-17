extends ScrollContainer

signal new_text_added(message: String)

@onready var message_text_lists = $MessageTextList
var message_count_name = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Called when position has to change when new message comes.
func _change_message_text_list_position():
	await get_tree().process_frame
	var current_size = message_text_lists.size.y
	if current_size - 110 > 4:
		message_text_lists.position.y = - (current_size - 110)
		print(message_text_lists.position.y)
		print("Changing positions.")
	
## Adding text. No need for upwards signals... considering this is a downward
## slope to this function.
func add_new_text(text_message: String, is_player: bool, is_choice: bool):
	var pre_text = preload("res://scenes/device/messaging/message_text_box.tscn")
	
	if is_player:
		pre_text = preload("res://scenes/device/messaging/message_text_box_from_player.tscn")
	else:
		# Also play audio too while you're at it. And ring phone.
		Events.ring_phone.emit()
		AudioManager.sfx_play(AudioManager.phone_new_message_sfx)
	
	var new_text = pre_text.instantiate()
	
	new_text.post_text = text_message
	if is_player:
		new_text.is_choice = is_choice
		#new_text.post_text = "[right]" + new_text.post_text + "[/right]"
	
	# And then add it to the parent Contact List.
	message_text_lists.add_child(new_text)
	message_count_name += 1
	new_text.name = str(message_count_name)
	
	# Changes only if not the player.
	if not is_player:
		new_text_added.emit(text_message)
	
	#_change_message_text_list_position()

func _on_message_text_list_draw():
	print("Rect changed")
	_change_message_text_list_position()

