# Contributors:
# - willnationsdev
#
# Description:
# HoverContainer is a simple container that emits signals when left/right 
# mouse clicks occur over it as well as periodic emissions while the mouse
# is hovering over it. The rate at which hover signals are emitted can be
# controlled from the editor.

extends Container

signal mouse_hovering(position, velocity)
signal mouse_left_clicked(position, velocity)
signal mouse_right_clicked(position, velocity)

export var _hover_emission_rate = 1.0 setget set_hover_emission_rate, get_hover_emission_rate

var _is_hovering = false setget , is_hovering
var _hover_accumulator = 0.0
var _last_mouse_position = Vector2(0,0) setget , get_last_mouse_position

var _lc = "hover_container_left_click"
var _rc = "hover_container_right_click"

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	_setup_actions()

func _fixed_process(p_delta):
	_hover_accumulator += p_delta
	
	# Needed because Input.get_last_mouse_speed() does not update when not
	# moving between frames. Ergo, a steady mouse will not return Vector2(0,0).
	var true_speed = Vector2(0,0)
	
	if _is_hovering:
		if _hover_accumulator >= _hover_emission_rate:
			if get_viewport().get_mouse_position() != _last_mouse_position:
				true_speed = Input.get_last_mouse_speed()
			
			_last_mouse_position = get_viewport().get_mouse_position()
			
			emit_signal("mouse_hovering", _last_mouse_position, true_speed)
			
			while _hover_accumulator >= _hover_emission_rate:
				_hover_accumulator -= _hover_emission_rate
		
		if Input.is_action_just_pressed(_lc):
			emit_signal("mouse_left_clicked", _last_mouse_position, true_speed)
		if Input.is_action_just_pressed(_rc):
			emit_signal("mouse_right_clicked", _last_mouse_position, true_speed)

func _on_mouse_entered():
	_is_hovering = true

func _on_mouse_exited():
	_is_hovering = false

func _setup_actions():
	if not InputMap.has_action(_lc):
		InputMap.add_action(_lc)
		var ev = InputEventMouseButton.new()
		ev.set_button_index(BUTTON_LEFT)
		ev.set_doubleclick(false)
		ev.set_factor(1)
		InputMap.action_add_event(_lc,ev)
	
	if not InputMap.has_action(_rc):
		InputMap.add_action(_rc)
		var ev = InputEventMouseButton.new()
		ev.set_button_index(BUTTON_RIGHT)
		ev.set_doubleclick(false)
		ev.set_factor(1)
		InputMap.action_add_event(_rc,ev)

func is_hovering():
	return _is_hovering

func get_last_mouse_position():
	return _last_mouse_position

func set_hover_emission_rate(p_hover_rate):
	_hover_emission_rate = p_hover_rate

func get_hover_emission_rate():
	return _hover_emission_rate