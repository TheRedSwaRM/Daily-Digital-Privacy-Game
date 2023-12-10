extends Node2D
@onready var bathroom = $ToBathroom
@onready var background = $Control/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.check_game_switch("night"):
		background.texture = load("res://assets/images/bg/room2_night.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_to_bathroom_input_detected():
	if Events.check_game_switch("night"):
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "bathroom_check")
	else:
		Events.change_map.emit("res://scenes/areas/bathroom_door.tscn")


func _on_click_area_component_input_detected():
	if Events.check_game_switch("night"):
		AudioManager.bgm_stop()

		await get_tree().create_timer(1).timeout
		
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "evening")
		await DialogueManager.dialogue_ended
		
		await get_tree().create_timer(1).timeout
		
		Events.deactivate_phone.emit()
		Events.change_map.emit("res://scenes/cutscenes/creep_incoming.tscn")
	else:
		DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/knocking.dialogue"), "morning")
		
