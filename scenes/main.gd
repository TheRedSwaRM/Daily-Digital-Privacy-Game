extends Node

@onready var phone = $Phone
@onready var transition_sprite = $BlinkingEye
@export_file var starting_screen
#
#	if event is InputEventMouseMotion and event.button_mask > 0:
#		cave.position.x = clampf(cave.position.x + event.relative.x, -CAVE_LIMIT, 0)

func _ready():
	# Adding events
	Events.change_map.connect(_goto_area)
	Events.change_map.emit(starting_screen)
	
	# For flipping
	phone.flipping_phone.connect(_change_mouse_passing_for_phone)
	
	# For debugging
	phone.debug_connection_change.connect(_change_connection_debug)
	phone.debug_location_change.connect(_change_location_debug)
	
	# To Remove
	# phone.unflip_phone.connect(_on_phone_unflip)
	#print("is this even working?")
	


func _unhandled_input(event):
	if get_tree().paused: return	# Safety measure :skull:
	#if event is InputEventKey and event.pressed and !event.is_echo():
		#match event.keycode:
			#KEY_ESCAPE:
				#get_tree().paused = true
				#pause_menu.open_menu()
		# print(get_viewport().get_visible_rect().size/2 - $Area.get_local_mouse_position())
		# print($Area.get_local_mouse_position())

## Goes to another area.
func _goto_area(path: String):
	if ResourceLoader.exists(path):
		transition_sprite.play("blinking_transition")
		await transition_sprite.animation_finished
		
		call_deferred("_deferred_change_area", path)
		
		transition_sprite.play_backwards("blinking_transition")
		await transition_sprite.animation_finished
	
## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path: String):
	var current_scene = get_node("Area")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "Area"
	move_child(current_scene, 0)
	
## If true, allow filter to pass through... else.
func _change_mouse_passing_for_phone(value: bool):
	if value:
		phone.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		phone.mouse_filter = Control.MOUSE_FILTER_PASS

#==============================================================================
# Debugger function
#==============================================================================
func _change_connection_debug(connection: String):
	%ConName.text = connection
	
func _change_location_debug(value: bool):
	%LocYesNo.text = str(value)
