extends Control

@onready var permission_list = $PermList
@onready var continue_button = $ContinueButton
signal return_button_pressed
signal continue_button_pressed(permission_only: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# All in one JUST IN CASE
func _permission_button_pressed(toggled_on: bool):
	# Original, only need phone to proceed.
	#for child in permission_list.get_children():
		#if child.button_pressed != true:
			#continue_button.hide()
			#return
	
	if toggled_on:
		continue_button.show()
	else:
		continue_button.hide()

func _on_return_button_pressed():
	return_button_pressed.emit()

func _on_continue_button_pressed():
	var truth_val: bool = false
	for child in permission_list.get_children():
		if child.button_pressed == true and child.name != "PhonePerm":
			truth_val = true
			
	continue_button_pressed.emit(truth_val)
