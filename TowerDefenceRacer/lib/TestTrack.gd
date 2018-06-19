extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_button_down():
	get_tree().change_scene("res://Scenes/lobby.tscn")



func _on_Button2_button_down():
	get_tree().change_scene("res://Scenes/.tscn")
