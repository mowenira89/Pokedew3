class_name State extends Node

var state_machine:StateMachine
var entity:Entity

func init():
	pass
	
func enter():
	pass
	
func exit():
	pass
	
func process(delta)->State:
	return null
	
func physics(delta)->State:
	return null

func handle_input(event)->State:
	return null
