class_name Tool extends Equipment

enum tool_type {Hoe,Axe,Pickaxe,Basket,Hammer,Wrench,Screwdriver,ChefKnife,Wisk,Spatula,WateringCan}

@export var type:tool_type

func use(target:Entity=null):
	var tile = TileManager.get_tile()
	if tile in TileManager.covered_tiles:
		var covered_tile=TileManager.covered_tiles[tile]
		if covered_tile is Breakable:
			if InvHelper.selected_item.data.type in covered_tile.tool_type :
				covered_tile.take_damage(1)
				return
