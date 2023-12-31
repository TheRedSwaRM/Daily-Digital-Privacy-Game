@tool
extends PanelContainer

@export var user_name: String
@export var post_image: Texture2D
@export_multiline var location: String
@export_multiline var post_text: String

@onready var user_name_button = $VBoxContainer/Profile
@onready var image_node = $VBoxContainer/PostContainer/PostImage
@onready var location_label = $VBoxContainer/Location
@onready var post_text_node = $VBoxContainer/PostContainer/PostText


# Called when the node enters the scene tree for the first time.
func _ready():
	user_name_button.text = user_name
	
	if post_image == null:
		image_node.hide()
	else:
		image_node.show()
		image_node.texture = post_image
	
	if not location == "":
		location_label.show()
		location_label.text = location
		
	post_text_node.text = post_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		user_name_button.text = user_name
		image_node.texture = post_image
		if not location_label.text == "":
			location_label.show()
			location_label.text = location
		post_text_node.text = post_text
