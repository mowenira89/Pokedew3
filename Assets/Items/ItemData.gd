class_name ItemData extends Resource

@export var data_name:String
@export var name:String
@export var description:String
@export var effects:Array[Effect]
@export var max_stack:int=99
var texture:get=get_texture
@export var organic:bool
@export var burn_time:int=0
@export var value:int

func get_texture():
	return "res://Assets/Sprites/Items/"+data_name+".png"

func use(target:Entity=null):
	pass
