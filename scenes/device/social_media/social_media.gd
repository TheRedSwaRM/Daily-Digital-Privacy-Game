extends Control

@onready var home_feed = $HomeFeed
@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost
@onready var signup_screen = $SignupScreen
@onready var login_screen = $LogIn
@onready var permission_screen = $PermissionsScreen
@onready var new_post_screen = $NewPostPanel

@onready var sns_post_num: int = 0

## Dictates if any actions can be done.
@onready var online: bool = false
@onready var connection_status_panel = $NoConnectionPanel
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_add_post.connect(sns_add)
	Events.connection_change.connect(_check_for_wifi_connection)
	Events.back_button_pressed.connect(_phone_back_button_pressed)
	signup_screen.signup_complete.connect(login_screen.registration_successful)
	visibility_changed.connect(_day_2_chatter_event)
	_check_for_wifi_connection("none")
	#Events.location_change.connect(_change_location_debug)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
#signal connection_change(name: String)
#signal location_change(value: bool)

#func _signup_completed():
	#Events.new_phone_message.emit("Friender", "Welcome to Friender!")
	#Events.new_phone_message.emit("Friender", "Welcome to Friender!")
	#signup_screen.hide()

func _check_for_wifi_connection(connection_name: String):
	match connection_name:
		"none":
			online = false
			connection_status_panel.show()
			print("SNS Offline")
		_:
			online = true
			connection_status_panel.hide()
			print("SNS Online")
	
func _on_home_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		home_feed.scroll_vertical = home_feed.scroll_vertical - event.relative.y

func sns_add(username: String, sns_text: String, loc: String = "", sns_image: Texture2D = null):
	var new_post = preload("res://scenes/device/social_media/social_media_post.tscn")
	var adding_post = new_post.instantiate()
	
	adding_post.user_name = username
	adding_post.post_text = sns_text
	
	adding_post.post_image = sns_image
	adding_post.location = loc
	
	sns_post_num += 1
	adding_post.name = str(sns_post_num) 
	
	home_post_list.add_child(adding_post)

func _on_add_post_button_pressed():
	new_post_screen.show()
	#if not online:
		#anim_player.play("no_connection")
		#AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
		#return
	#
	#AudioManager.sfx_play("res://assets/audio/sfx/sns_notif.mp3")
	#if Events.location:
		#Events.sns_add_post.emit("Cheryl", "Kinda bored ngl.", "Yakal St.", load("res://assets/images/social_media/default_image.png"))
		#Events.change_game_switch("posted_with_location", true)
	#else:
		#Events.sns_add_post.emit("Cheryl", "Kinda bored ngl.", "", null)


func _on_profile_button_pressed():
	pass # Replace with function body.


func _on_friends_button_pressed():
	pass # Replace with function body.


func _on_message_button_pressed():
	pass # Replace with function body.


func _on_notification_button_pressed():
	pass # Replace with function body.

#===============================================================================
# LOGIN SCREEN FUNCTIONS
#===============================================================================

## Only works if there is data in log-in.
func _on_log_in_login_button_pressed():
	permission_screen.show()
	login_screen.hide()

func _on_log_in_signup_button_pressed():
	login_screen.hide()
	signup_screen.show()

#===============================================================================
# SIGNUP SCREEN FUNCTIONS
#===============================================================================

func _on_signup_screen_signup_return_button():
	login_screen.show()
	signup_screen.hide()

#===============================================================================
# PERMISSIONS SCREEN FUNCTIONS
#===============================================================================

func _on_permissions_screen_return_button_pressed():
	permission_screen.hide()
	login_screen.show()


func _on_permissions_screen_continue_button_pressed():
	Events.change_game_switch("WARNING_permissions_set", true)
	permission_screen.hide()
	login_screen.hide()
	
	# Forcing it back to the start.
	_phone_back_button_pressed()

#===============================================================================
# BACK PHONE FUNCTIONS
#===============================================================================

func _phone_back_button_pressed():
	# First because they'll be the first ones the player will see.
	# Login screen cannot be hidden because it is... special.
	if signup_screen.visible:
		_on_signup_screen_signup_return_button()
		return
	elif permission_screen.visible:
		_on_permissions_screen_return_button_pressed()
		return
	
	# After registration.
	if new_post_screen.visible:
		_on_new_post_panel_return_button_pressed()
		return
	
	# If everything is not visible.
	hide()

#===============================================================================
# NEW POST FUNCTIONS
#===============================================================================

func _on_new_post_panel_return_button_pressed():
	new_post_screen.hide()

func _on_new_post_panel_send_button_pressed():
	new_post_screen.hide()

func _on_new_post_panel_send_attempt_on_no_wifi():
	anim_player.play("no_connection")

func _day_2_chatter_event():
	if visible and Events.day_counter == 2:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "checking_app")
		visibility_changed.disconnect(_day_2_chatter_event)
	else:
		print("Not yet Day 2")
