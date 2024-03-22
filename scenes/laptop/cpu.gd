extends CharacterBody2D
var cpu_speed = 4000
@onready var ball_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_reference = get_tree().get_nodes_in_group("ball")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dist_y = ball_reference.position.y - position.y
	var input_dir = 0
	var allow_computation = 1
	var dist_x = position.x - ball_reference.position.x
	
	if (dist_x < 80 or ball_reference.direction.x > 0):
		if abs(dist_y) < 2.5:
			allow_computation = 0
		else:
			input_dir = 1 if dist_y > 0 else -1
	else:
		allow_computation = 0
		
	velocity = Vector2(0, input_dir).normalized() * delta * cpu_speed * allow_computation
	move_and_slide()
