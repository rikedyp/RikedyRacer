extends "basic_sedan.gd"

export (int) var hue_shift
var red = 0.8
var green = 0.8
var blue = 0.8
var a = 1
var t = 0

func _ready():
	pass
	#$label.text = delta

func _process(delta):
	t += delta*hue_shift
	var b = 0
	red = 0.5*(sin(t-b)+1)
	b = 2#*hue_shift
	blue = 0.5*(sin(t-b)+1)
	b = 4#*hue_shift
	green = 0.5*(sin(t-b)+1)
	#if t > 1:
	#	t = 0
	#var h = t
#	var b = 0.3
#	var c = 0.15
#	red = exp(-((h-b)*(h-b))/(2*c*c))
#	b = 0.6
#	c = 0.3
#	green = exp(-((h-b)*(h-b))/(2*c*c))
#	b = 0.7
#	blue = exp(-((h-b)*(h-b))/(2*c*c))
	#$label.text = "["+str(stepify(red,0.01))+","+str(stepify(green,0.01))+","+str(stepify(blue,0.01))+"]"
	$animated_sprite.modulate = Color(red,green,blue)
	$red.value = red
	$blue.value = blue
	$green.value = green
	$hue.value = sin(t)
