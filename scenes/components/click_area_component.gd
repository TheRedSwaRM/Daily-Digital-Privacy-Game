extends Area2D
class_name ClickableArea

## Name for the label in the case that it would be hovered over by the mouse.
## Default: NULL
@export var label_name: String

## Collision shape created after instantiation.
@export var collision_shape: CollisionPolygon2D

## The PackedScene to switch to in the case of pressing this area.
@export var transfer_area: PackedScene

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
