extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("")
	self.add_item("Jen")
	self.add_item("Carl")
	self.add_item("Mary")
	self.add_item("Mike")
	self.add_item("Angel")
	self.add_item("Mia")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
