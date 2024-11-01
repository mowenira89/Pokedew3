class_name Idle extends State

@onready var walk = $"../Walk"


func init():
	pass
	
func enter():
	entity.UpdateAnimation('default')
	
	
func exit():
	pass
	
func process(delta)->State:
	if entity.direction!=Vector2.ZERO: 
		return walk
	entity.velocity = Vector2.ZERO
	return null
	
func physics(delta)->State:
	return null

func handle_input(event)->State:
	return null

func Exit()->void:
	pass
	
