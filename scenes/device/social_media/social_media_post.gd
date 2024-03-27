#@tool
extends PanelContainer

signal profile_link_pressed(username: String)

@export var user_name: String
@export var post_image: Texture2D
@export_multiline var location: String
@export_multiline var post_text: String

@onready var user_name_button = $VBoxContainer/ProfileContainer/ProfileButton
@onready var image_node = $VBoxContainer/PostContainer/PostImage
@onready var location_label = $VBoxContainer/Location
@onready var post_text_node = $VBoxContainer/PostContainer/PostText
@onready var like_number = $VBoxContainer/StatLine/LikeContainer/LikeNumber
@onready var share_number = $VBoxContainer/StatLine/ShareContainer/ShareNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.sns_like_share_event.connect(_randomized_like_share_get)
	user_name_button.text = user_name
	
	if post_image == null:
		image_node.hide()
	else:
		image_node.texture = post_image
		image_node.show()
		
	
	if not location == "":
		location_label.show()
		location_label.text = location
		
	post_text_node.text = post_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		user_name_button.text = user_name
		if post_image == null:
			image_node.texture = null
			image_node.hide()
		else:
			image_node.texture = post_image
			image_node.show()
			
		if location == "":
			location_label.hide()
		else:
			location_label.show()
			location_label.text = location
		post_text_node.text = post_text

func increase_likes():
	var random_number = randi_range(1, 10)
	like_number.text = str(int(like_number.text) + random_number)
	if user_name == Events.social_media_username:
		Events.sns_new_notif.emit(Events.NotifType.LIKE, "Random Person")
	
func increase_shares():
	var random_number = randi_range(1, 10)
	share_number.text = str(int(share_number.text) + random_number)
	if user_name == Events.social_media_username:
		Events.sns_new_notif.emit(Events.NotifType.SHARE, "Random Person")
	
func _on_profile_pressed():
	profile_link_pressed.emit(user_name)

func _randomized_like_share_get():
	if randi_range(0, 4) > 2:
		increase_likes()
	if randi_range(0, 4) > 2:
		increase_shares()
