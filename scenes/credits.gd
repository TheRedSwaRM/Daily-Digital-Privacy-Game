extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5).timeout 
	Events.quit_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
