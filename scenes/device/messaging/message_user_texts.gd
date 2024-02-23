extends ScrollContainer

signal new_text_added(message: String)

@onready var message_text_lists = $MessageTextList

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Adding text. No need for upwards signals... considering this is a downward
## slope to this function.
func add_new_text(text_message: String, is_player: bool, is_choice: bool):
	var pre_text = preload("res://scenes/device/messaging/message_text_box.tscn")
	if is_player:
		pre_text = preload("res://scenes/device/messaging/message_text_box_from_player.tscn")
		
	var new_text = pre_text.instantiate()
	
	
	new_text.post_text = text_message
	if is_player:
		new_text.is_choice = is_choice
		new_text.post_text = "[right]" + new_text.post_text + "[/right]"
	
	# And then add it to the parent Contact List.
	message_text_lists.add_child(new_text)
	new_text_added.emit(text_message)
	
	# Also play audio too while you're at it. And ring phone.
	Events.ring_phone.emit()
	AudioManager.sfx_play(AudioManager.phone_new_message_sfx)
