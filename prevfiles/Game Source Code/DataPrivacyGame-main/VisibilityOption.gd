extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("Only Friends")
	self.add_item("Friends of Friends")
	self.add_item("Everyone")

