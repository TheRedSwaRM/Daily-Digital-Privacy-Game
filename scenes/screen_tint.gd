@tool
extends CanvasModulate

@export var gradient_texture: GradientTexture1D
const min_per_hour = 60
const game_to_irl_min = (2 * PI) / 1440

var time: float = 0.0

@export var initial_hour = 12:
	set(h):
		initial_hour = h
		time = game_to_irl_min * min_per_hour * initial_hour

func _change_color(curr_time: float):
	var value = (sin(curr_time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

func _change_color_signal(curr_time: float):
	time = game_to_irl_min * min_per_hour * curr_time
	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.game_time = initial_hour
	time = game_to_irl_min * min_per_hour * initial_hour
	_change_color(time)
	Events.change_time.connect(_change_color_signal)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		_change_color(time)
