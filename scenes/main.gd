extends Node

@export var current_scene: Node2D
@onready var pause_menu = $PauseMenu

func _ready():
	var new_scene = "res://scenes/bedroom.tscn"
	goto_area(new_scene)


func _unhandled_input(event):
	if get_tree().paused: return	# Safety measure :skull:
	if event is InputEventKey and event.pressed and !event.is_echo():
		match event.keycode:
			KEY_ESCAPE:
				get_tree().paused = true
				pause_menu.open_menu()

## Goes to anotehr area.
func goto_area(path):
	call_deferred("_deferred_change_area", path)

## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path):
	current_scene = get_node("Area")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "Area"
	move_child(current_scene, 0)
