extends PanelContainer

@export_multiline var post_text: String


@onready var text_messsage = $TextMessage
# Called when the node enters the scene tree for the first time.
func _ready():
	text_messsage.text = post_text
	var parse_text = text_messsage.get_parsed_text()
	if len(parse_text) > 16:
		set_custom_minimum_size(Vector2(16*2.75+6,6))
	else:
		set_custom_minimum_size(Vector2(len(parse_text)*2.75+6,6))
		#set_size(Vector2(parse_text*4,6))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_text_message_meta_clicked(meta):
	Events.back_button_pressed.emit()
	Events.link_pressed.emit(meta)
