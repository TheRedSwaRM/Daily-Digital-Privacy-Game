extends PanelContainer

@export_multiline var post_text: String
@export var is_choice: bool

@onready var text_messsage = $TextMessage
@onready var choice_theme = preload("res://scenes/components/messaging_text_box_from_player_choice.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_choice:
		theme = choice_theme
	
	text_messsage.text = post_text
	
	var parse_text = text_messsage.get_parsed_text()
	print(len(parse_text))
	print(parse_text)
	if len(parse_text) > 16:
		set_custom_minimum_size(Vector2(16*2.75+4,6))
	else:
		set_custom_minimum_size(Vector2(len(parse_text)*2.75+4,6))
		#set_size(Vector2(parse_text*4,6))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_text_message_meta_clicked(meta):
	Events.back_button_pressed.emit()
	Events.link_pressed.emit(meta)
