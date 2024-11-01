extends TextureRect
@onready var label: Label = $Label
var is_placeable:bool=false

func change_label(q):
	if q==1 or q==0:
		label.visible=false
	else:
		label.text=str(q)
		label.visible=true
