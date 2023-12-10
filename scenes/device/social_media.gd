extends Control

@onready var home_feed = $HomeFeed
@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost

@onready var sns_post_num: int = 0

## Dictates if any actions can be done.
@onready var online: bool = false
@onready var connection_status_panel = $NoConnectionPanel
@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_add_post.connect(sns_add)
	Events.connection_change.connect(_check_for_wifi_connection)
	#Events.location_change.connect(_change_location_debug)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
#signal connection_change(name: String)
#signal location_change(value: bool)

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
	if not online:
		anim_player.play("no_connection")
		AudioManager.sfx_play("res://assets/audio/sfx/error_social_media.mp3")
		return
	
	var new_post = preload("res://scenes/device/social_media_post.tscn")
	var adding_post = new_post.instantiate()
	
	adding_post.user_name = username
	adding_post.post_text = sns_text
	
	adding_post.post_image = sns_image
	adding_post.location = loc
	
	sns_post_num += 1
	adding_post.name = str(sns_post_num) 
	
	home_post_list.add_child(adding_post)


func _on_add_post_button_pressed():
	Events.sns_add_post.emit("gay sex", "gaygay", "", null)
