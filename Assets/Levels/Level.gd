extends Node2D

var breakables = {
	'tree1'="res://Assets/Breakables/Tree.tscn",
	'tree2'="res://Assets/Breakables/Tree2.tscn",
	'stone'="res://Assets/Breakables/BreakableStone.tscn",
	'fiber'="res://Assets/Breakables/BreakableStone.tscn",
	'log'="res://Assets/Breakables/BreakableStone.tscn"
}

func _ready():
	TileManager.tilemap = find_child("TileMap")
	set_breakables()

func set_breakables():
	var tilemap = TileManager.tilemap
	var tree1 = tilemap.get_used_cells_by_id(2,5,Vector2(0,3))
	var tree2 = tilemap.get_used_cells_by_id(2,8,Vector2(0,0))
	var stone1 = tilemap.get_used_cells_by_id(2,7,Vector2(0,0))
	var stone2 = tilemap.get_used_cells_by_id(2,7,Vector2(1,0))
	var stone3 = tilemap.get_used_cells_by_id(2,7,Vector2(2,0))
	var fiber = tilemap.get_used_cells_by_id(2,7,Vector2(4,0))
	var log = tilemap.get_used_cells_by_id(2,7,Vector2(3,0))
	var tiles = [tree1,tree2,stone1,stone2,stone3,fiber,log]
	var data_names = ['tree1','tree2','stone','stone','stone','fiber','log']

	for t in range(0,tiles.size()):
		for tile in tiles[t]:
			tilemap.set_cell(2,tile,-1,Vector2(-1,-1))
			if data_names[t] in ['tree1','tree2']:
				tile.y+=2
			
			var b_coord = tilemap.map_to_local(tile)
			var new_breakable = load(breakables[data_names[t]])
			var new_b = new_breakable.instantiate()
			add_child(new_b)
	
			if new_b is BreakableStone:
				if data_names[t]=='stone':
					new_b.sprite.frame=randi()%3
				elif data_names[t]=='fiber':
					new_b.sprite.frame=4
				elif data_names[t]=='log':
					new_b.sprite.frame=3
			new_b.set_breakable(tile)
			TileManager.covered_tiles[tile]=new_b
			new_b.global_position=b_coord
			
