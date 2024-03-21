extends Control

@onready var animation_player = $AnimationPlayer
@onready var hacked_text = $HackedText

func _get_user_name_from_player():
	var output = []
	match OS.get_name():
		"Windows":
			OS.execute("CMD.exe", ["/C", "echo %USERNAME%"], output)
		"macOS":
			OS.execute("id", ["-un"], output)
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			OS.execute("id", ["-un"], output)
		"Android":
			output.append(OS.get_environment("USER"))
		"iOS":
			output.append(OS.get_environment("USER"))
		
	hacked_text.text = "..." + str(output[0])

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	_check_for_route()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Checks on what to do when given something.
func _check_for_route():
	## If player is hacked.
	if Events.hack_checker():
		_get_user_name_from_player()
		animation_player.play("hacked_ending")
		await animation_player.animation_finished
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/cutscenes/hacked_scare_scene.tscn")
		
	## If player can sleep.
	elif Events.check_game_switch("PLAYER_can_sleep"):
		animation_player.play("sleep_ending")
		await animation_player.animation_finished
		await get_tree().create_timer(2).timeout 
		Events.quit_game()
		
	## If player spams until player blocks.
	elif Events.check_game_switch("BLOCK_attacker_num"):
		animation_player.play("block_ending")
		await animation_player.animation_finished
		await get_tree().create_timer(2).timeout 
		Events.quit_game()
		
	## If player gets jebaited.
	elif Events.check_game_switch("PLAYER_bamboozle"):
		animation_player.play("baited_ending")
		await animation_player.animation_finished
		await get_tree().create_timer(2).timeout 
		Events.quit_game()
		
	## Failsafe.
	else:
		#animation_player.play("hacked_ending")
		#await animation_player.animation_finished
		#await get_tree().create_timer(2).timeout
		#get_tree().change_scene_to_file("res://scenes/cutscenes/hacked_scare_scene.tscn")
		await get_tree().create_timer(5).timeout 
		Events.quit_game()
