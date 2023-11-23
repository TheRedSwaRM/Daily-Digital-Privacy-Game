extends Node

@onready var pause_menu = $PauseMenu
@onready var mouse_position = %MousePos
@export var starting_screen: PackedScene
#
#	if event is InputEventMouseMotion and event.button_mask > 0:
#		cave.position.x = clampf(cave.position.x + event.relative.x, -CAVE_LIMIT, 0)


func _ready():
	var new_scene = starting_screen.resource_path
	goto_area(new_scene)


func _unhandled_input(event):
	if get_tree().paused: return	# Safety measure :skull:
	if event is InputEventKey and event.pressed and !event.is_echo():
		match event.keycode:
			KEY_ESCAPE:
				get_tree().paused = true
				pause_menu.open_menu()
	if event is InputEventMouseMotion:
		mouse_position.target_position = $Area.get_local_mouse_position() - get_viewport().get_visible_rect().size/2
		# print(get_viewport().get_visible_rect().size/2 - $Area.get_local_mouse_position())
		# print($Area.get_local_mouse_position())

## Goes to another area.
func goto_area(path: String):
	call_deferred("_deferred_change_area", path)

## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path: String):
	var current_scene = get_node("Area")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "Area"
	move_child(current_scene, 0)
	
