class_name LootDropper extends Node

func drop_loot(item:String):
	var new_item = Item.new()
	new_item.create_item(item,1)
	var new_pickup:Pickup = InvHelper.pickup.instantiate()
	get_parent().add_child(new_pickup)
	new_pickup.create_pickup(new_item)
	var pos = $".".global_position
	pos.x+=randi_range(10,90)
	new_pickup.global_position=pos
