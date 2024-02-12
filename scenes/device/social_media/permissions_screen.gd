extends Control

@onready var permission_list = $PermList
@onready var continue_button = $ContinueButton
signal return_button_pressed
signal continue_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# All in one JUST IN CASE
func _permission_button_pressed():
	for child in permission_list.get_children():
		if child.button_pressed != true:
			continue_button.hide()
			return
	
	# If all perms are true, it will reach this line of code.
	continue_button.show()

func _on_return_button_pressed():
	return_button_pressed.emit()

func _on_continue_button_pressed():
	continue_button_pressed.emit()
