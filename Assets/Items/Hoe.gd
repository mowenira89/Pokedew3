class_name Hoe extends Tool

func use(target:Entity=null):
	super()
	var tile = TileManager.get_tile()
	var tilemap = TileManager.tilemap
	var tillability:TileData = tilemap.get_cell_tile_data(1,tile)
	var plantability = tilemap.get_cell_tile_data(2,tile)
	if plantability != null: 
		if plantability.get_custom_data("can_plant") and tile not in TileManager.covered_tiles:
			tilemap.erase_cell(2,tile)
	elif tillability.get_custom_data("can_till"):
		if tile not in TileManager.covered_tiles:
			tilemap.set_cell(2,tile,6,Vector2(0,0))
