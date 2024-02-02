extends PanelContainer

@export_multiline var post_text: String

@onready var text_messsage = $TextMessage
# Called when the node enters the scene tree for the first time.

func _ready():
	text_messsage.text = post_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
