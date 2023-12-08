extends Control

@onready var home_feed = $HomeFeed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_home_feed_gui_input(event):
	
	# For scrolling purposes.
	if event is InputEventMouseMotion and event.button_mask > 0:
		home_feed.scroll_vertical = home_feed.scroll_vertical - event.relative.y
