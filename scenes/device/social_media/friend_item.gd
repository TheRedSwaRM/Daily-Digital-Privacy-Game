extends PanelContainer

@onready var friend_icon_texture = $friendItems/friendIcon
@onready var friend_text_line = $friendItems/friendText

@export var friend_name: String


# Called when the node enters the scene tree for the first time.
func _ready():
	friend_text_line.text = friend_name
	name = friend_name
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		friend_text_line.text = friend_name
