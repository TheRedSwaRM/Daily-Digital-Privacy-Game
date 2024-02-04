extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.back_button_pressed.connect(_phone_back_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Special function
func _phone_back_button_pressed():
	hide()
