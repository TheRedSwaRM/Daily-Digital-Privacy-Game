extends Control

@onready var blur = $Blur

func open_menu():
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func close_menu():
	get_tree().paused = false
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	if !get_tree().paused: return
	if event is InputEventKey and event.pressed and !event.is_echo():
		match event.keycode:
			KEY_ESCAPE:
				accept_event()
				close_menu()


func _on_resume_button_pressed():
	close_menu()


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
