@tool
extends Button

@export var wifi_name: String
@export var wifi_password: String
@export var has_access: bool

@onready var default_theme = preload("res://scenes/components/wifi_button.tres")
@onready var activated_theme = preload("res://scenes/components/wifi_button_activated.tres")
@onready var wifi_default_icon = preload("res://assets/images/device/wifi_icon.png")
@onready var wifi_activated_icon = preload("res://assets/images/device/wifi_icon_connected.png")
@onready var wifi_haspass_icon = preload("res://assets/images/device/wifi_haspass_icon.png")

signal wifi_button_pressed(self_node: Button, toggle: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	name = wifi_name
	text = wifi_name
	set_default_icon()

func _process(_delta):
	if Engine.is_editor_hint():
		if wifi_name != "":
			name = wifi_name
		text = wifi_name
		set_default_icon()

func set_default_icon():
	if button_pressed == true:
		set_theme(activated_theme)
		icon = wifi_activated_icon
	else:
		set_theme(default_theme)
		if wifi_password != "":
			icon = wifi_haspass_icon
		else:
			icon = wifi_default_icon

func _on_toggled(toggled_on):
	set_default_icon()
	wifi_button_pressed.emit(self, toggled_on)
	
