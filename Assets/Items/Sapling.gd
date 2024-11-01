class_name Sapling extends ItemData

@export var species:String

func use(target:Entity=null):
	var tile = TileManager.get_tile()
	var tilemap = TileManager.tilemap
	var tile_data = tilemap.get_cell_tile_data(1,tile)
	var tillability = tile_data.get_custom_data("can_till")
	if tillability and tile not in TileManager.covered_tiles:
		var new_tree = load("res://Assets/Breakables/"+species+".tscn")
		var tree = new_tree.instantiate()
		tilemap.add_child(tree)
		tree.set_stage(1)
		tree.global_position = tilemap.map_to_local(tile)
		InvHelper.remove_inv_item(MainMenu.hotbar_inv,MainMenu.hotbar_inv[MainMenu.selected_index],1)
