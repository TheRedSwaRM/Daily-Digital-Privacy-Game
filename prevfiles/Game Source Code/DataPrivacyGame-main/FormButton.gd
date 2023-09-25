extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var background = get_node("../../Background")
onready var eventForm = get_node("../../EventForm")
var inv_form = load("res://.import/Invitation Form.png-3614c99d7aff29e78df0c8b4f58c79df.stex")

# Called when the node enters the scene tree for the first time.
func _ready():
	eventForm.visible = false
	pass # Replace with function body.

func _pressed():
	print("FormButton pressed!")
	background.texture = null
	eventForm.texture = inv_form
	eventForm.visible = true
	self.disabled = true
	self.visible = false
	
