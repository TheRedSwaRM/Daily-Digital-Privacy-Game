extends Node

@onready var phone = $Phone
@onready var phone_settings = $Phone/PhoneContainer/Settings				# This is not a pretty solution.
@onready var transition_sprite = $BlinkingEye
@export_file var starting_screen
@export var debugger_on: bool

# Reserved for events... wait do I need it?
@onready var event_done_1: bool = false

# Woops.


func _ready():
	#===========================================================================
	# Mandatory Stuff
	#===========================================================================
	# Adding events
	Events.change_map.connect(_goto_area)
	Events.change_map.emit(starting_screen)
	
	# For flipping
	phone.flipping_phone.connect(_change_mouse_passing_for_phone)
	
	# For debugging
	Events.connection_change.connect(_change_connection_debug)
	Events.location_change.connect(_change_location_debug)
	
	Events.activate_phone.connect(_show_phone)
	Events.deactivate_phone.connect(_hide_phone)
	
	Events.open_blinking_eye.connect(_open_blinking_eye)
	
	if debugger_on:
		%Debugger.show()
	
	#===========================================================================
	# Cutscenes
	#===========================================================================
	Events.game_switch_changed.connect(_cutscene_social_post)
	
	
## Goes to another area.
func _goto_area(path: String, special: bool = false):
	if ResourceLoader.exists(path):
		transition_sprite.play("blinking_transition")
		await transition_sprite.animation_finished
		
		call_deferred("_deferred_change_area", path)
		
		if not special:
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
		phone.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_phone():
	phone.show()

func _hide_phone():
	phone.hide()

func _open_blinking_eye():
	transition_sprite.play_backwards("blinking_transition")
	await transition_sprite.animation_finished

#==============================================================================
# Debugger function
#==============================================================================
func _change_connection_debug(connection: String):
	%ConName.text = connection
	
func _change_location_debug(value: bool):
	%LocYesNo.text = str(value)

#==============================================================================
# Events
#==============================================================================
func _cutscene_social_post(key: String, value: bool):
	if Events.check_game_switch(key) && key == "posted_with_location":
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/intro.dialogue"))
		await DialogueManager.dialogue_ended
		Events.game_switch_changed.disconnect(_cutscene_social_post)


