extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_direction = Input.get_axis("ui_up","ui_down")
	velocity = Vector2(0, input_direction).normalized() * delta * 100
	move_and_collide(velocity)
