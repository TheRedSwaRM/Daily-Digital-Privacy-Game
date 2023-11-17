extends Control


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_continue_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	accept_event()
	get_tree().quit()
