class_name FiniteStateMachine
extends Node2D

# Handles the state
# stores the current state, switches states

@export var state: State


# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(state)
	pass # Replace with function body.

func change_state(new_state: State):
	if state is State: # check against null
		state._exit_state()
	new_state._enter_state()
	state = new_state



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
