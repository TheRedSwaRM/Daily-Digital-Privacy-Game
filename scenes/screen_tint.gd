extends CanvasModulate

@export var gradient_texture: GradientTexture1D
const min_per_hour = 60
const game_to_irl_min = (2 * PI) / 1440

@export_category("Time")



# Called when the node enters the scene tree for the first time.
func _ready():
	_change_color(Events.game_time)
	Events.change_time.connect(_change_color_signal)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _change_color(curr_time: float):
	var new_time = game_to_irl_min * min_per_hour * curr_time
	var value = (sin(new_time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

func _change_color_signal(curr_time: float):
	#var tween = get_tree().create_tween()
	var new_time = game_to_irl_min * min_per_hour * curr_time
	var value = (sin(new_time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)
