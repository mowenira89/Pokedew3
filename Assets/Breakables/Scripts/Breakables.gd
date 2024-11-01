class_name Breakable extends StaticBody2D

var hp
var max_hp
var tool_type:Array[Tool.tool_type]
var tile:Vector2i

func take_damage(damage):
		hp-=damage
		if hp<=0:
			break_breakable()
			
func break_breakable():
	pass
	
func set_breakable(t:Vector2i):
	tile = t

func entered(body):
	if body.is_in_group("Player"):
		print('entered')
		get_parent().modulate("#ffffff80")	
	
func exited(body):
	if body.is_in_group("Player"):
		get_parent().modulate("#ffffffff")

func interact():
	if InvHelper.selected_item.data is Tool:
		if tool_type in InvHelper.selected_item.data.type:
			take_damage(1)			
	
