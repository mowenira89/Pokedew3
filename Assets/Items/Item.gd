class_name Item extends Resource

var quantity:int
@export var data:ItemData

func use(target:Entity=null):
	print('used')
	
func create_item(data_name:String,q:int):
	data = load("res://Assets/Resources/Items/"+data_name+".tres")
	quantity=q
