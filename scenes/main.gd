extends Node

@export var current_scene: Node2D


func _ready():
	var new_scene = "res://scenes/bedroom.tscn"
	goto_area(new_scene)

func goto_area(path):
	call_deferred("_deferred_change_area", path)

func _deferred_change_area(path):
	var current_scene = get_node("Area")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	get_tree().root.add_child(current_scene)
	current_scene.name = "Area"
