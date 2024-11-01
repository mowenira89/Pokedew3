class_name InvItem extends ItemData

@export var inv_size:int
var inv = []

func _ready():
	inv.resize(inv_size)
