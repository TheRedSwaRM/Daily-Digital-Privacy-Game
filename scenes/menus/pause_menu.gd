extends Control

func open_menu():
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func close_menu():
	get_tree().paused = false
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	if !get_tree().paused: return
	accept_event()
	if event is InputEventKey and event.pressed and !event.is_echo():
		match event.keycode:
			KEY_ESCAPE:
				
				close_menu()
