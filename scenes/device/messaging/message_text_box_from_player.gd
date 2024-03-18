extends PanelContainer

@export_multiline var post_text: String
@export var is_choice: bool

@onready var text_messsage = $TextMessage
@onready var choice_theme = preload("res://scenes/components/messaging_text_box_from_player_choice.tres")
@onready var respondent_name = get_parent().get_parent().name

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_choice:
		# This is stupid. Please don't do this. Like, fr.
		theme = choice_theme
		add_to_group(respondent_name)
		text_messsage.text = "[i]" + post_text + "[/i]"
	else:
		text_messsage.gui_input.disconnect(_on_text_message_gui_input)
		text_messsage.text = post_text
	
	var parse_text = text_messsage.get_parsed_text()
	
	if len(parse_text) > 16:
		set_custom_minimum_size(Vector2(16*2.75+4,6))
	else:
		set_custom_minimum_size(Vector2(len(parse_text)*2.75+4,6))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_text_message_meta_clicked(meta):
	Events.back_button_pressed.emit()
	Events.link_pressed.emit(meta)

func _on_text_message_gui_input(event):
	if Events.mouse_left_click(event):
		Events.message_response.emit(respondent_name, post_text)
		get_tree().call_group(respondent_name, "_remove_choices")

func _remove_choices():
	queue_free()


func _on_text_message_mouse_entered():
	if is_choice: GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)


func _on_text_message_mouse_exited():
	GameSettings.change_cursor_look()
