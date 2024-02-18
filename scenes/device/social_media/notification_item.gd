@tool
extends PanelContainer

@onready var notif_icon_follow = preload("res://assets/images/social_media/notification_follow.png")
@onready var notif_icon_like = preload("res://assets/images/social_media/notification_like.png")
@onready var notif_icon_share = preload("res://assets/images/social_media/notification_share.png")

@onready var notif_icon_texture = $NotifItems/NotifIcon
@onready var notif_text_line = $NotifItems/NotifText

@export_multiline var notif_text: String
@export var notif_type: Events.NotifType


# Called when the node enters the scene tree for the first time.
func _ready():
	match notif_type:
		Events.NotifType.FOLLOW:
			notif_icon_texture.texture = notif_icon_follow
		Events.NotifType.LIKE:
			notif_icon_texture.texture = notif_icon_like
		Events.NotifType.SHARE:
			notif_icon_texture.texture = notif_icon_share
			
	notif_text_line.text = notif_text
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		match notif_type:
			Events.NotifType.FOLLOW:
				notif_icon_texture.texture = notif_icon_follow
			Events.NotifType.LIKE:
				notif_icon_texture.texture = notif_icon_like
			Events.NotifType.SHARE:
				notif_icon_texture.texture = notif_icon_share
				
	notif_text_line.text = notif_text
