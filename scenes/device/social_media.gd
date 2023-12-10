extends Control

@onready var home_feed = $HomeFeed
@onready var home_post_list = $HomeFeed/HomePosts/TheActualPost

@onready var sns_post_num: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_home_feed_gui_input(event):
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		home_feed.scroll_vertical = home_feed.scroll_vertical - event.relative.y

#@export var user_name: String
#@export var post_image: Texture2D
### ONLY FOR PRE-MADE POSTS!
#@export var show_location_post: bool
#@export_multiline var location: String
#@export_multiline var post_text: String
func sns_add(username: String, sns_text: String, show_loc: bool = false, loc: String = "", sns_image: Texture2D = null):
	var new_post = preload("res://scenes/device/social_media_post.tscn")
	var adding_post = new_post.instantiate()
	
	adding_post.user_name = username
	adding_post.post_text = sns_text
	
	adding_post.post_image = sns_image
	adding_post.location = loc
	
	sns_post_num += 1
	adding_post.name = str(sns_post_num) 
	
	home_post_list.add_child(adding_post)
