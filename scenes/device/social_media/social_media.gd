extends Control

#region Initialization

@onready var home_feed = $HomeFeed
@onready var notif_feed = $NotificationFeed
@onready var profile_feed = $SocialMediaAccounts/Player
@onready var friend_feed = $FriendFeed

@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost
@onready var notif_post_list = $NotificationFeed/NotifPosts/NotifList
@onready var friend_feed_list = $FriendFeed/FriendMasterList/FriendList
@onready var account_list = $SocialMediaAccounts
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
@onready var simulation_timer = $SimulationTimer

## Social Media Buttons
@onready var profile_button = $SNSButtons/ProfileButton
@onready var friends_button = $SNSButtons/FriendsButton
@onready var message_button = $SNSButtons/MessageButton
@onready var notification_button = $SNSButtons/NotificationButton

@onready var profile_button_idle = load("res://assets/images/social_media/social_media_prof.png")
@onready var friends_button_idle = load("res://assets/images/social_media/social_media_friends.png")
@onready var message_button_idle = load("res://assets/images/social_media/social_media_mes.png")
@onready var notification_button_idle = load("res://assets/images/social_media/social_media_bell.png")


@onready var profile_button_hover = load("res://assets/images/social_media/social_media_prof_active.png")
@onready var friends_button_hover = load("res://assets/images/social_media/social_media_friends_active.png")
@onready var message_button_hover = load("res://assets/images/social_media/social_media_mes_active.png")
@onready var notification_button_hover = load("res://assets/images/social_media/social_media_bell_active.png")


#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_add_post.connect(sns_add)
	Events.sns_new_notif.connect(_new_notification_item)
	Events.sns_add_friend.connect(_add_friend)
	
	Events.connection_change.connect(_check_for_wifi_connection)
	Events.back_button_pressed.connect(_phone_back_button_pressed)
	
	signup_screen.signup_complete.connect(login_screen.registration_successful)
	
	#Events.location_change.connect(_change_location_debug)
	
	# Initializing Player Profile Account's Stuff when changing.
	Events.get_social_media_name.connect(_change_player_profile)
	
	# When Day 3 arrives.
	Events.game_switch_changed.connect(_disable_social_media)
	
	# Added for debugging purposes.
	if get_parent() != get_tree().root:
		login_screen.show()
	else:
		Events.wifi_connection = "Yipee"
	
	_check_for_wifi_connection("none")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#region Scrolling Functions
func _on_home_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		home_feed.scroll_vertical = home_feed.scroll_vertical - event.relative.y

func _on_notification_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		notif_feed.scroll_vertical = notif_feed.scroll_vertical - event.relative.y

func _on_friend_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		friend_feed.scroll_vertical = friend_feed.scroll_vertical - event.relative.y
#endregion

#region SNS Adding Function
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
	
	## Connect signal in order for profile to show up. Like, for real.
	adding_post.profile_link_pressed.connect(_show_account_profile)

func _on_add_post_button_pressed():
	new_post_screen.show()
	
func _on_new_post_panel_return_button_pressed():
	_on_home_button_pressed()

func _on_new_post_panel_send_button_pressed():
	new_post_screen.hide()

func _on_new_post_panel_send_attempt_on_no_wifi():
	anim_player.play("no_connection")
	
#endregion

#region Button Pressing Functions

func _hide_feeds():
	home_feed.hide()
	notif_feed.hide()
	friend_feed.hide()

## Special because this is different from the rest.
func _on_profile_button_pressed():
	current_tab_label.text = "Profile"
	_hide_feeds()
	_show_account_profile(profile_feed.name)
	
func _on_friends_button_pressed():
	current_tab_label.text = "Friends"
	_hide_feeds()
	friend_feed.show()

func _on_message_button_pressed():
	current_tab_label.text = "Message"
	_hide_feeds()

func _on_notification_button_pressed():
	current_tab_label.text = "Alerts"
	_hide_feeds()
	notif_feed.show()

func _on_home_button_pressed():
	current_tab_label.text = "home"
	_hide_feeds()
	home_feed.show()

#endregion

#region Log In Functions

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

#endregion

#region Friend Feed Functions

func _add_friend(user_name: String):
	# Checking if the friend already exists, so we don't bother with possible
	# re-friends. Not much time-consuming as most would expect.
	for friend in friend_feed_list.get_children():
		if friend.name == user_name: return

	var new_friend = preload("res://scenes/device/social_media/friend_item.tscn")
	var adding_friend = new_friend.instantiate()
	adding_friend.friend_name = user_name

	# Add and then make new notification.
	friend_feed_list.add_child(adding_friend)
	_new_notification_item(Events.NotifType.FOLLOW, user_name)
	
#endregion

#region Permission Functions (obsolete)
func _on_signup_screen_signup_return_button():
	login_screen.show()
	signup_screen.hide()

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
	
#endregion

#region Phone Back options
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
	account_list.hide()

#endregion

#region Notifications Tab

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

#endregion

#region Specific Profile Accounts Handling

func _show_account_profile(user_name: String):
	for account in account_list.get_children():
		print(account.name, user_name)
		if account.name == user_name:
			account.show()
			account_list.show()
			break

func _change_player_profile(username: String):
	profile_feed.name = username

#endregion

#region Miscellaneous Functions
func _day_2_chatter_event():
	if Events.day_counter == 2:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/social_media.dialogue"), "checking_app")
		
	else:
		print("Not yet Day 2")

func _disable_social_media(key: String, _value: bool):
	if Events.check_game_switch(key) && key == "deactivate_social_media":
		print("Disabled social media.")
		Events.game_switch_changed.disconnect(_disable_social_media)
		disable_screen.show()

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

#endregion

#region Social Media Icons when Hovered

func _on_profile_button_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)
	profile_button.icon = profile_button_hover

func _on_profile_button_mouse_exited():
	GameSettings.change_cursor_look()
	profile_button.icon = profile_button_idle

func _on_friends_button_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)
	friends_button.icon = friends_button_hover

func _on_friends_button_mouse_exited():
	GameSettings.change_cursor_look()
	friends_button.icon = friends_button_idle

func _on_message_button_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)
	message_button.icon = message_button_hover

func _on_message_button_mouse_exited():
	GameSettings.change_cursor_look()
	message_button.icon = message_button_idle

func _on_notification_button_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)
	notification_button.icon = notification_button_hover

func _on_notification_button_mouse_exited():
	GameSettings.change_cursor_look()
	notification_button.icon = notification_button_idle

func _on_home_button_mouse_entered():
	GameSettings.change_cursor_look(GameSettings.CursorLook.INTERACT)

func _on_home_button_mouse_exited():
	GameSettings.change_cursor_look()

#endregion

#===============================================================================
# DANGER: Like, literal fucking danger. This is experimental at best.
# Events.check_game_switch("enable_social_media_simulation")
# DANGER: This thing will ALWAYS BE TICKING ONCE THE GAME STARTS. It only needs
# DANGER: ONE SWITCH. And that is above this danger text. That's all!
#===============================================================================

#region Social Media Simulation
func _on_simulation_timer_timeout():
	# Don't do anything if the following is on.
	if not Events.check_game_switch("enable_social_media_simulation"): return
	# And if this thing exists.
	if Events.check_game_switch("deactivate_social_media"): return
	
	
	
#endregion




