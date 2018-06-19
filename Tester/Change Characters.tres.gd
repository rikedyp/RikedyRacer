extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var toggle = 0
func _ready():
	pass

	# Called every time the node is added to the scene.
	# Initialization here


func _process(delta):
	pass

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_Pirate_button_up():
	$Pirate.active = true
	$Player.active = false
	$Ranger.active = false
	print ('Pirate')

func _on_Ninja_button_up():
	$Pirate.active = false
	$Player.active = true
	$Ranger.active = false
	print('Ninja')

func _on_Ranger_button_up():
	print('Ranger')
	$Pirate.active = false
	$Player.active = false
	$Ranger.active = true
