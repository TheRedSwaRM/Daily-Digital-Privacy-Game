extends Node2D

@onready var player_score_label = $PlayerScore
@onready var cpu_score_label = $CPUScore

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ball_pong_score(scorer):
	match scorer:
		"Player":
			player_score_label.text = str(int(player_score_label.text) + 1)
		"CPU":
			cpu_score_label.text = str(int(cpu_score_label.text) + 1)
