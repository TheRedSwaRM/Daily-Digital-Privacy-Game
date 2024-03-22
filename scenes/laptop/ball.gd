extends CharacterBody2D
var direction = Vector2()
var speed = 100

signal pong_score(scorer: String)

func _ready():
	add_to_group("ball")
	direction = Vector2(randf_range(-0.5, 0.5), randf_range(-0.15, 0.15)).normalized()

func _randomized_direction():
	position = Vector2(125.5, 69)
	speed = 100
	direction = Vector2(randf_range(-0.5, 0.5), randf_range(-0.15, 0.15)).normalized()

func _physics_process(delta):
	velocity = speed * direction
	var collision = move_and_collide(velocity * delta)
	# check if there is a collision:
	if collision:
		# Bounce!
		direction = direction.bounce(collision.get_normal())
		
		# And then a few things
		match collision.get_collider().name:
			"CPU", "Player":
				speed += 50
			"PlayerSide":
				pong_score.emit("CPU")
				_randomized_direction()
			"CPUSide":
				pong_score.emit("Player")
				_randomized_direction()
