extends Control

@onready var day_label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	day_label.text = "Day " + str(Events.day_counter)
	await get_tree().create_timer(3).timeout
	
	day_label.show()
	await get_tree().create_timer(5).timeout
	
	day_label.hide()
	await get_tree().create_timer(1).timeout
	
	Events.change_map.emit("res://scenes/intro.tscn", false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
