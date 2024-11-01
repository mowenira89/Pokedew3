extends Node

func _ready():
	Signals.breakable_clicked.connect(breakable_clicked)
	
func breakable_clicked(breakable:Breakable):
	print(breakable)
	if InvHelper.selected_item.data is Tool:
		if InvHelper.selected_item.data.type in breakable.data.tool_type:
			breakable.take_damage(1)
			print('reached')
