extends Control

signal thumbnail_touched(tab_name: String)

@onready var tab_thumb_name = $TabName
@onready var tab_thumb_image = $TabThumbnail
@export var link_data: String
@export var node_name: String
@export var tab_name: String
@export var tab_image: String


# Called when the node enters the scene tree for the first time.
func _ready():
	tab_thumb_name.text = tab_name
	tab_thumb_image.texture = load(tab_image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		thumbnail_touched.emit(node_name)
