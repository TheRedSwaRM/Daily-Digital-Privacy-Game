extends Control

@onready var home_feed = $HomeFeed
@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost
@onready var signup_screen = $SignupScreen

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
	signup_screen.signup_complete.connect(_signup_completed)
	_check_for_wifi_connection("none")
	#Events.location_change.connect(_change_location_debug)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
#signal connection_change(name: String)
#signal location_change(value: bool)

func _signup_completed():
	Events.new_phone_message.emit("Friender", "Welcome to Friender!")
	signup_screen.hide()

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
	if not online:
		anim_player.play("no_connection")
		AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
		return
	
	AudioManager.sfx_play("res://assets/audio/sfx/sns_notif.mp3")
	if Events.location:
		Events.sns_add_post.emit("Cheryl", "Kinda bored ngl.", "Yakal St.", load("res://assets/images/social_media/default_image.png"))
		Events.change_game_switch("posted_with_location", true)
	else:
		Events.sns_add_post.emit("Cheryl", "Kinda bored ngl.", "", null)

func _phone_back_button_pressed():
	hide()


func _on_profile_button_pressed():
	pass # Replace with function body.


func _on_friends_button_pressed():
	pass # Replace with function body.


func _on_message_button_pressed():
	pass # Replace with function body.


func _on_notification_button_pressed():
	pass # Replace with function body.
