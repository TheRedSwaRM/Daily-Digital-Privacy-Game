extends Control

@onready var home_feed = $HomeFeed
@onready var notif_feed = $NotificationFeed
@onready var profile_feed = $ProfileFeed

@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost
@onready var notif_post_list = $NotificationFeed/NotifPosts/NotifList
@onready var current_tab_label = $CurrentTabLabel

@onready var signup_screen = $SignupScreen
@onready var login_screen = $LogIn
@onready var permission_screen = $PermissionsScreen
@onready var new_post_screen = $NewPostPanel
@onready var disable_screen = $DisabledScreen

@onready var sns_post_num: int = 0

## Dictates if any actions can be done.
@onready var online: bool = false
@onready var connection_status_panel = $NoConnectionPanel
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_add_post.connect(sns_add)
	Events.sns_new_notif.connect(_new_notification_item)
	Events.connection_change.connect(_check_for_wifi_connection)
	Events.back_button_pressed.connect(_phone_back_button_pressed)
	
	signup_screen.signup_complete.connect(login_screen.registration_successful)
	_check_for_wifi_connection("none")
	#Events.location_change.connect(_change_location_debug)
	
	# When Day 3 arrives.
	Events.game_switch_changed.connect(_disable_social_media)
	
	# initialization
	login_screen.show()

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

func _on_notification_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		notif_feed.scroll_vertical = notif_feed.scroll_vertical - event.relative.y

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

func _hide_feeds():
	home_feed.hide()
	notif_feed.hide()

func _on_profile_button_pressed():
	current_tab_label.text = "Profile"
	profile_feed.show()

func _on_friends_button_pressed():
	current_tab_label.text = "Friends"

func _on_message_button_pressed():
	current_tab_label.text = "Message"

func _on_notification_button_pressed():
	current_tab_label.text = "Notifications"
	_hide_feeds()
	notif_feed.show()

func _on_home_button_pressed():
	current_tab_label.text = "home"
	_hide_feeds()
	home_feed.show()

#===============================================================================
# LOGIN SCREEN FUNCTIONS
#===============================================================================

## Only works if there is data in log-in.
func _on_log_in_login_button_pressed():
	# Originally there was a permission screen... but we're trying to make it
	# like it's nothing IMPORTANT.
	# permission_screen.show()
	
	# The act of even doing the app is already a problem. Will add an option
	# that the player can actually read whatever the hell the privacy stuff are
	# that is set by the app.
	#Events.change_game_switch("WARNING_permissions_set", true)
	#Events.change_game_switch("signup_complete", true)
	_day_2_chatter_event()
	login_screen.hide()
	
	# Forcing phone back.
	#_phone_back_button_pressed()

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
# PERMISSIONS SCREEN FUNCTIONS !OBSOLETE
#===============================================================================

func _on_permissions_screen_return_button_pressed():
	permission_screen.hide()
	login_screen.show()


func _on_permissions_screen_continue_button_pressed(value: bool):
	if value:
		Events.change_game_switch("WARNING_permissions_set", true)
	Events.change_game_switch("signup_complete", true)
	permission_screen.hide()
	login_screen.hide()
	
	# Forcing it back to the start.
	_phone_back_button_pressed()

#===============================================================================
# BACK PHONE FUNCTIONS
#===============================================================================

func _phone_back_button_pressed():
	if not visible:
		print("Social Media already not visible.")
		return
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
		new_post_screen._on_return_button_pressed()
		return
	if profile_feed.visible:
		_on_profile_feed_back_button_pressed()
		return
	
	# If everything is not visible.
	hide()

func _on_profile_feed_back_button_pressed():
	profile_feed.hide()

#===============================================================================
# NEW POST FUNCTIONS
#===============================================================================

func _on_new_post_panel_return_button_pressed():
	_on_home_button_pressed()

func _on_new_post_panel_send_button_pressed():
	new_post_screen.hide()

func _on_new_post_panel_send_attempt_on_no_wifi():
	anim_player.play("no_connection")

func _day_2_chatter_event():
	if Events.day_counter == 2:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "checking_app")
	else:
		print("Not yet Day 2")

func _new_notification_item(post_type: Events.NotifType, content_string: String):
	var new_notif_item = preload("res://scenes/device/social_media/notification_item.tscn")
	var adding_notif_item = new_notif_item.instantiate()
	var notif_string: String = ""
	
	match post_type:
		Events.NotifType.FOLLOW:
			notif_string = content_string + " followed you."
		Events.NotifType.LIKE:
			notif_string = content_string + " liked your post."
		Events.NotifType.SHARE:
			notif_string = content_string + " shared your post."
	
	adding_notif_item.notif_type = post_type
	adding_notif_item.notif_text = notif_string
	
	notif_post_list.add_child(adding_notif_item)
	
	#match post_type:
		#Events.NotifType.FOLLOW:
			#

func _disable_social_media(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "deactivate_social_media":
		print("Disabled social media.")
		Events.game_switch_changed.disconnect(_disable_social_media)
		disable_screen.show()
