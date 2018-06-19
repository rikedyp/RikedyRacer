# Contributors
# - willnationsdev
# 
# Description:
# BaseSwitcher lets you cycle through a set of "target nodes" (for which a derived class must
# implement a find_targets method). Then an application method is applied to all target nodes.
# If the currently examined node matches the index of the current selection, then it should
# behave somewhat differently from the rest. Cycling can be clamped or looped, applications
# can be inverted and/or automatically triggered upon changes.

extends Node

export(bool) var automatic = true    # Whether to automatically apply switch when settings are changed
export(bool) var allow_cycles = true # Whether to cycle to the other end of the set when passed the edge
export(bool) var reversed = false    # Whether to reverse all calls to next() and previous()

export(bool) var inverted = false setget on_inverted # Whether to invert the application function's effects
export var custom_inverted_func = ""                 # Function to call on targets when inverted
export(bool) var disabled = false setget on_disabled # Whether to toggle off the switcher's effects on its targets
export var custom_disabled_func = ""                 # Function to call on targets when disabled

export(int) var index_switch = 0 setget set_index_switch   # The index of the selected node
export(String) var name_switch = "" setget set_name_switch # The name of the selected node

var targets = []  # The total set of nodes being examined

var _is_first_update = true      # Without this, "original" in setters blocks editor-defined values
var _has_derived_entered = false # Without this, switch_type is prematuraly set to default SWITCH_VISIBILITY during index/name_switch init

# Needed for tool functionality
func _enter_tree():
	_is_first_update = false # this will end up running LAST, after any derived version's _enter_tree methods

# Needed for runtime functionality, not a big deal if it runs twice
func _ready():
	pass

func set_index_switch(p_index):
	if not _has_derived_entered: return
	var original = index_switch if !_is_first_update else p_index
	index_switch = (p_index + (targets.size()*abs(p_index)) ) % targets.size()
	find_targets(false)
	# Only leave side effects if the new value results in identified targets
	if not targets.empty():
		name_switch = targets[index_switch].get_name()
	else:
		index_switch = original
	
func set_name_switch(p_name):
	if not _has_derived_entered: return
	if p_name == "": return
	var original = name_switch if !_is_first_update else p_name
	name_switch = p_name
	find_targets(true)
	# Only leave side effects if the new value results in identified targets
	if not targets.empty():
		var search = targets.find(p_name)
		index_switch = search if search != -1 else index_switch
	else:
		name_switch = original

func next():
	shift(1)

func previous():
	shift(-1)

func shift(p_offset):
	var offset = p_offset * (-1 if reversed else 1)
	index_switch += offset
	if (allow_cycles):
		var mod_neg = targets.size()*abs(offset) # prevent negative modulus from staying negative
		index_switch = (index_switch+mod_neg) % targets.size()
	else: index_switch = clamp(index_switch,0,targets.size()-1)
	if (automatic) and not disabled: apply()

func apply():
	pass

func find_targets(p_use_name):
	pass

func on_disabled(p_disabled):
	pass

func on_inverted(p_inverted):
	pass

func get_target():
	return targets[index_switch] if !targets.empty() else null