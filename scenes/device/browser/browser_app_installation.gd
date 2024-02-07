extends Control

@export var link_name: String
@export var tab_name: String
@export_file("*.png") var thumbnail

@onready var no_wifi = $NoWifi

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Show the no wifi page
func no_wifi_page(value: bool):
	print(value)
	if value:
		no_wifi.hide()
	else:
		no_wifi.show()

func _on_install_button_pressed():
	Events.force_phone_go_to.emit("Installer")
