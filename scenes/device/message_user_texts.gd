extends ScrollContainer

signal new_text_added()

@onready var message_text_lists = $MessageTextList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Adding text. No need for upwards signals... considering this is a downward
## slope to this function.
func add_new_text(text_message: String):
	var pre_text = preload("res://scenes/device/message_text_box.tscn")
	var new_text = pre_text.instantiate()
	
	new_text.post_text = text_message
	
	# And then add it to the parent Contact List.
	message_text_lists.add_child(new_text)
	new_text_added.emit()
