extends Area2D

@export var label_name: String
@export var collision_shape: CollisionPolygon2D
@onready var label_node: Label = $Label

signal input_detected

func _ready():
	label_node.text = label_name
	label_node.position = collision_shape.position
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		input_detected.emit()


func _on_mouse_entered():
	label_node.visible = true


func _on_mouse_exited():
	label_node.visible = false
