extends Node2D

var cursor:Cursor
var tilemap:TileMap
var p:Player
var covered_tiles = {}

func get_tile()->Vector2i:
		var coord:Vector2i = tilemap.local_to_map(cursor.global_position)
		return coord

func _physics_process(delta):	
	if PlayerManager.player!=null:
		p = PlayerManager.player
		var player_tile = tilemap.local_to_map(p.global_position)
		if p.auto_aiming:
			var indicator_tile = player_tile
			match p.last_direction:
				Vector2.DOWN:indicator_tile.y+=1
				Vector2.UP: indicator_tile.y-=1
				Vector2.LEFT:indicator_tile.x-=1
				Vector2.RIGHT:indicator_tile.x+=1
			cursor.global_position=tilemap.map_to_local(indicator_tile)
		else:
			cursor.global_position=tilemap.map_to_local(tilemap.local_to_map(get_global_mouse_position()))
			
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if InvHelper.selected_item!=null:
			InvHelper.selected_item.data.use()
	if event.is_action_pressed("interact"):
		var tile = get_tile()
		if tile in covered_tiles:
			covered_tiles[tile].interact()
	
