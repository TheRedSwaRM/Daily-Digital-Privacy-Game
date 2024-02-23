extends Control

signal send_button_pressed
signal send_attempt_on_no_wifi

@onready var disabled_location_icon = preload("res://assets/images/social_media/social_media_location_icon_disabled.png")
@onready var activated_location_icon = preload("res://assets/images/social_media/social_media_location_icon.png")

@onready var location_button = $PostScrollContainer/PostPanel/PostContainer/OtherButtons/LocationButton

@onready var post_text = $PostScrollContainer/PostPanel/PostContainer/PostContent/PostText
@onready var post_image = $PostScrollContainer/PostPanel/PostContainer/PostContent/PostImage

@onready var post_scroll_container = $PostScrollContainer
@onready var drafts_scroll_container = $DraftsScrollContainer
@onready var return_button = $ReturnButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_return_button_pressed():
	if drafts_scroll_container.visible:
		post_scroll_container.show()
		drafts_scroll_container.hide()
		return_button.text = "X"
	else:
		hide()

## For back button in social media. Propagation issues.
func _back_button_good():
	if drafts_scroll_container.visible:
		return false
	else:
		return true

func _on_send_button_pressed():
	if Events.wifi_connection != "None": 	# Currently connected
		if post_text.text == "":			# Checks if post is not empty
			AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
			return
		
		# If not, continue
		if location_button.button_pressed: # Location on.
			Events.sns_add_post.emit(Events.social_media_username, post_text.text, Events.social_media_location, post_image.texture)
			Events.change_game_switch("WARNING_posted_with_location", true)
		else:
			Events.sns_add_post.emit(Events.social_media_username, post_text.text, "", post_image.texture)
		
		# Clean up and exit.
		Events.change_game_switch("posted_in_sns", true)
		post_text.text = ""
		_on_return_button_pressed()
		return
		
	else:
		send_attempt_on_no_wifi.emit()
		AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
		return

func _on_location_button_toggled(toggled_on):
	if toggled_on:
		location_button.icon = activated_location_icon
	else:
		location_button.icon = disabled_location_icon

func _on_drafts_button_pressed():
	post_scroll_container.hide()
	drafts_scroll_container.show()
	return_button.text = "<"

func _draft_message_picked(text: String):
	post_text.text = text
	_on_return_button_pressed()
	

func _on_rich_text_label_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel.text)
		
func _on_rich_text_label_2_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel2.text)

func _on_rich_text_label_3_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel3.text)

func _on_rich_text_label_4_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel4.text)

func _on_rich_text_label_5_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel5.text)

func _on_rich_text_label_6_gui_input(event):
	if Events.mouse_left_click(event):
		_draft_message_picked($DraftsScrollContainer/DraftsPanel/DraftsList/RichTextLabel6.text)
