extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	_check_for_route()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Checks on what to do when given something.
func _check_for_route():
	await get_tree().create_timer(5).timeout 
	
	Events.quit_game()
