extends Control

signal back_button_pressed

@onready var header_user_name_label = $UpperLayer/UserName
@onready var user_name_label = $ProfileScroll/ProfileContainer/HeaderPart/HeaderContainer/UserName
@onready var join_date_label = $ProfileScroll/ProfileContainer/HeaderPart/HeaderContainer/JoinDate
@onready var post_list = $ProfileScroll/ProfileContainer/ProfilePosts/ProfilePostList
@onready var sns_post_num: int = 0
@onready var friends_number: int = 0


## Verifies if the following is the player.
@export var is_user: bool

## For bots only. :D
@export var user_name: String
@export var location: String # For their posts.

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_add_post.connect(_add_new_post)
	
	# Only for the player. No one else gets this signal.
	if is_user:
		Events.get_social_media_name.connect(_change_player_username)
	
	# Setup for bots.
	else:
		user_name_label.text = user_name
		header_user_name_label.text = user_name
		name = user_name
		join_date_label.text = "Joined 2024-" + str(randi_range(1,12)) + "-" + str(randi_range(1,29))
		_randomize_stats()

	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func _add_new_post(username: String, sns_text: String, loc: String = "", sns_image: Texture2D = null):
	# If not similar to player, then reject.
	if name != username: return 
	
	var new_post = preload("res://scenes/device/social_media/social_media_post.tscn")
	var adding_post = new_post.instantiate()
	
	adding_post.user_name = username
	adding_post.post_text = sns_text
	
	adding_post.post_image = sns_image
	adding_post.location = loc
	
	sns_post_num += 1
	adding_post.name = str(sns_post_num) 
	
	post_list.add_child(adding_post)

func _change_player_username(username: String):
	Events.get_social_media_name.disconnect(_change_player_username)
	user_name_label.text = username
	header_user_name_label.text = username
	join_date_label.text = "Joined " + Time.get_date_string_from_system()

func _on_return_button_pressed():
	back_button_pressed.emit()

func increase_friends():
	pass

## Only for bots.
func _randomize_stats():
	friends_number = randi_range(1, 100000)
