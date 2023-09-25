extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("")
	self.add_item("Jake")
	self.add_item("Sam")
	self.add_item("Cindy")
	self.add_item("Matt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
