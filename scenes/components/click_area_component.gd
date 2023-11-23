extends Area2D
class_name ClickableArea

## Name for the label in the case that it would be hovered over by the mouse.
## Default: NULL
@export var label_name: String

## Collision shape created after instantiation.
@export var collision_shape: CollisionPolygon2D


@export_category("Transfer Area")
## The PackedScene to switch to in the case of pressing this area.
## Note: Only have this WHEN you are sure that the following clickable area is 
## for transferring only. Otherwise, use input_detected.
@export var transfer_area: PackedScene

@onready var label_node: Label = $Label

## Use in place of in place of `input_event` connection in order to lessen
## overhead on certain things. Like `input_event` args.
signal input_detected

func _ready():
	label_node.text = label_name
	label_node.position = collision_shape.position
	
# You might think: isn't think a bit repetitive? Ask yourself: isn't it a bit
# too repetitive to just bust over the same function with the same arguments
# on the map no less? When you can just serialize this thing in a node? Yeah,
# I had my epiphany on that. IT JUST works.
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		input_detected.emit()

		if transfer_area != null:
			Events.change_map.emit(transfer_area.resource_path)

func _on_mouse_entered():
	label_node.visible = true


func _on_mouse_exited():
	label_node.visible = false
