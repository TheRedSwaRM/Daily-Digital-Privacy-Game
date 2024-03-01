@tool
extends CanvasModulate

@export var gradient_texture: GradientTexture1D
const min_per_hour = 60
const game_to_irl_min = (2 * PI) / 1440

@export_category("Time")
@export var time_passes_allowed: bool = true
@export var initial_hour: int = 6
@export var game_speed: int = 20



	#tween.tween_property(self, "color", gradient_texture.gradient.sample(value), 1).set_trans(Tween.TRANS_SINE)
	#await tween.finished
	
	#self.color = gradient_texture.gradient.sample(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.game_time = initial_hour
	_change_color(initial_hour)
	Events.change_time.connect(_change_color_signal)
	Events.change_time_speed.connect(_change_game_speed)
	Events.pause_game_time.connect(_pause_game)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		_change_color(initial_hour)
	else:
		if time_passes_allowed: 
			if Events.game_time > 24.0:
				Events.game_time = 0
			if Events.game_time < 18.0:
				Events.game_time += delta * game_to_irl_min * game_speed
	
func _change_color(curr_time: float):
	var new_time = game_to_irl_min * min_per_hour * curr_time
	var value = (sin(new_time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

func _change_color_signal(curr_time: float):
	#var tween = get_tree().create_tween()
	var new_time = game_to_irl_min * min_per_hour * curr_time
	var value = (sin(new_time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

func _change_game_speed(new_speed: int):
	game_speed = new_speed

func _pause_game(value: bool):
	time_passes_allowed = !value
