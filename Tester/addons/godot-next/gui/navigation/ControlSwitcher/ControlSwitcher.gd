# Contributors
# - willnationsdev
# 
# Description:
# ControlSwitcher lets you cycle through all child nodes and, assuming they are Control nodes, 
# set their visibility or focus properties accordingly as you move forward/backward in the list.
# It also lets you invert these modifications as well as have the cycling either stop at boundaries
# or loop back around to the other side.

extends "res://addons/godot-next/node_manipulation/BaseSwitcher/BaseSwitcher.gd"

enum { SWITCH_VISIBILITY, SWITCH_FOCUS, SWITCH_CUSTOM}

export(int, "Visibility", "Focus", "Custom") var switch_type = SWITCH_VISIBILITY setget set_switch_type

export var custom_switch_func = ""

func _enter_tree():
	_has_derived_entered = true
	find_targets(!name_switch.empty())
	apply()

func _ready():
	find_targets(!name_switch.empty())
	apply()

func set_switch_type(p_type):
	if _has_derived_entered:
		_revert()
	if p_type in [SWITCH_VISIBILITY, SWITCH_FOCUS, SWITCH_CUSTOM]:
		switch_type = p_type
	else:
		switch_type = SWITCH_VISIBILITY
	if _has_derived_entered:
		apply()

func find_targets(p_use_name):
	targets = get_children()
	if targets.size() > 0:
		if p_use_name:
			for i_target in range(0,targets.size()):
				if targets[i_target].get_name() == name_switch:
					index_switch = i_target
		else:
			if allow_cycles:
				index_switch = index_switch % targets.size()
			else:
				index_switch = clamp(index_switch,0,targets.size()-1)
	if (automatic) and not disabled: apply()

func apply():
	if switch_type == SWITCH_VISIBILITY:
		_apply_visibility()
	elif switch_type == SWITCH_FOCUS:
		_apply_focus()
	elif switch_type == SWITCH_CUSTOM and has_method(custom_switch_func):
		call(custom_switch_func)

func _apply_focus():
	for i_target in range(0,targets.size()):
		var condition = i_target == index_switch
		if inverted:
			if condition:
				targets[i_target].release_focus()
			else:
				targets[i_target].grab_focus()
		elif condition:
			targets[i_target].grab_focus()

func _apply_visibility():
	for i_target in range(0,targets.size()):
		var condition = i_target == index_switch
		targets[i_target].visible = (!condition if inverted else condition)

func on_disabled(p_disabled):
	disabled = p_disabled
	if not p_disabled:
		find_targets(false)
		apply()
		return
	_revert()
	if switch_type == SWITCH_CUSTOM and has_method(custom_disabled_func):
		call(custom_disabled_func)

func on_inverted(p_inverted):
	inverted = p_inverted
	if not inverted or switch_type != SWITCH_CUSTOM:
		find_targets(false)
		apply()
	elif has_method(custom_inverted_func):
		call(custom_inverted_func)

func _revert():
	if switch_type == SWITCH_VISIBILITY:
		for target in targets:
			target.visible = true
	elif switch_type == SWITCH_FOCUS:
		for target in targets:
			target.release_focus()