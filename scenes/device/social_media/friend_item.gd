extends PanelContainer

@onready var friend_icon_texture = $FriendItems/FriendIcon
@onready var friend_text_line = $FriendItems/FriendsText

@export var friend_name: String
@export var friend_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if friend_texture != null: friend_icon_texture = friend_texture
	friend_text_line.text = friend_name
	name = friend_name
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		friend_text_line.text = friend_name
