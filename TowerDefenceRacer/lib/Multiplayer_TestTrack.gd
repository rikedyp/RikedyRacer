extends Node2D
export (int) var MAXLAPS = 3
var camera
var dir
var countdown = 3
var ActivePlayer
# var multiplayer_id

func _ready():
	connect("Ready", self, "new_game")
	$HUD/Lap.text = "Lap: " + "1/" + str(MAXLAPS)
	if not is_network_master(): # why this?
		# Disable players during countdown
		for player in get_tree().get_nodes_in_group("players"):
			print(player.get_name() + " Ready.")
			player.ACTIVE = false
			#player.AnimatedSprite.set_frame(2)

	# By default, all nodes in server inherit from master,
	# while all nodes in clients inherit from slave.

	if (get_tree().is_network_server()):
		#If in the server, give control of player 2 to the other peer.
		#This function is tree recursive by default.
		ActivePlayer = get_node("Player1")
		get_node("Player2").set_network_master(get_tree().get_network_connected_peers()[0])
		camera = get_node("Player1/Camera")

		camera._set_current(true)
	else:
		#If in the client, give control of player 2 to itself.
		#This function is tree recursive by default.
		get_node("Player2").set_network_master(get_tree().get_network_unique_id())
		camera = get_node("Player2/Camera")
		ActivePlayer = get_node("Player2")
		camera._set_current(true)

	print("unique id: ",get_tree().get_network_unique_id())
	# might need to alter ActivePlayer method or delete
	# Get both players to confirm ready here
	$HUD/CDBG.show()
	$HUD/Countdown.show()
	$HUD/Countdown.text = str(countdown)
	$HUD/Timer.start()

func new_game():
	#This starts the game upon connection.
	var stage = load("res://Scenes/Multiplayer_TestTrack.tscn").instance()
	stage.connect("game_finished",self,"_end_game",[],CONNECT_DEFERRED) # connect deferred so we can safely erase it from the callback
	get_tree().get_root().add_child(stage)
	hide()
	pass

func _process(delta):
#	for player in get_tree().get_nodes_in_group("players"):
#		if player.lap <
	if ActivePlayer.lap < MAXLAPS + 1:
		var clockstring = "Time: " + str(stepify(ActivePlayer.time,0.01))
		$HUD/Clock.text = clockstring
	pass

func _on_Button2_button_down():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_PitStop_body_entered(body):
	if body.get_name() == ActivePlayer.get_name() and is_network_master():
		$TowerCam1.in_pitstop = true
		# Change Player1 to TowerEdit mode (player1 always master
		# TODO: More elegant solution which scales to >2 and/or flexible no. of players
		$TowerCam1/Camera.make_current()
	elif body.get_name() == ActivePlayer.get_name() and not is_network_master():
		$TowerCam2.in_pitstop = true
		# Change Player2 to TowerEdit mode
		$TowerCam2/Camera.make_current()

func _on_PitStop_body_exited(body):
	if body.get_name() == "Player1" and get_tree().is_network_server():
		$TowerCam1.in_pitstop = false
		$Player1/Camera.make_current()
		# Change Player1 to Racing mode
	elif body.get_name() == "Player2" and not get_tree().is_network_server():
		$TowerCam2.in_pitstop = false
		# Change Player2 to Racing mode
		$Player2/Camera.make_current()

func _on_TheLine_body_entered(body):
	if body.velocity.y < 0:
		dir = 1
	else:
		dir = -1

func _on_TheLine_body_exited(body):
	var lapstring
	# TODO: Figure out methods for any number (flexible number) of players
	if dir == 1 and body.velocity.y < 0:
		# This player going correct direction
		body.lap += 1
	elif dir == -1 and body.velocity.y > 0:
		# This player going wrong direction
		body.lap -= 1
	if body.lap > MAXLAPS:
		body.ACTIVE = false
		lapstring = "Lap: " + str(MAXLAPS) + "/" + str(MAXLAPS) + " FINISHED"
	else:
		lapstring = "Lap: " + str(body.lap) + "/" + str(MAXLAPS)


	#lapstring = "huh"
	if body.get_name() == ActivePlayer.get_name():
		$HUD/Lap.text = lapstring
		if body.lap > MAXLAPS:
			$HUD/AgainButton.show()
			
			# queue free?
			
func show_lobby():
	var lobby = load("res://Scenes/Lobby.tscn").instance()
	get_tree().get_root().add_child(lobby)

func _on_AgainButton_pressed():
	call_deferred("show_lobby")
	get_tree().set_network_peer(null)
	propagate_call("queue_free", [])

func _on_HUD_countdown_timeout():
	if countdown > -1:
		countdown -= 1
		if countdown == 0:
			ActivePlayer.ACTIVE = true
			$HUD/Countdown.hide()
			$HUD/CDBG.hide()
		$HUD/Countdown.text = str(countdown)
	else:
		$HUD/Timer.stop()
