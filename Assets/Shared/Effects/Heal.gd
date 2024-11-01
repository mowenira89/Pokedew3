class_name Heal extends Effect

@export var heal_amount:int

func use(target:Entity=null):
	target.update_hp(heal_amount)
