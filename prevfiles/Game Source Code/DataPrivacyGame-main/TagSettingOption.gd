extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("Always review tags.")
	self.add_item("No one can tag you in their posts.")
	self.add_item("Allow anyone to tag you in their post.")

