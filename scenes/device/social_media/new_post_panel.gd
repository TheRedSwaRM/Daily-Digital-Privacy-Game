extends Control

signal return_button_pressed
signal send_button_pressed
signal send_attempt_on_no_wifi

@onready var disabled_location_icon = preload("res://assets/images/social_media/social_media_location_icon_disabled.png")
@onready var activated_location_icon = preload("res://assets/images/social_media/social_media_location_icon.png")

@onready var location_button = $ScrollContainer/PostPanel/PostContainer/OtherButtons/LocationButton

@onready var post_text = $ScrollContainer/PostPanel/PostContainer/PostContent/PostText
@onready var post_image = $ScrollContainer/PostPanel/PostContainer/PostContent/PostImage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_return_button_pressed():
	return_button_pressed.emit()

func _on_send_button_pressed():
	if Events.wifi_connection != "None": 	# Currently connected
		if post_text.text == "":			# Checks if post is not empty
			AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
			return
		
		# If not, continue
		if location_button.button_pressed: # Location on.
			Events.sns_add_post.emit(Events.social_media_username, post_text.text, Events.social_media_location, post_image.texture)
			Events.change_game_switch("posted_with_location", true)
		else:
			Events.sns_add_post.emit(Events.social_media_username, post_text.text, "", post_image.texture)
		
		# Clean up and exit.
		post_text.text = ""
		return_button_pressed.emit()
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
