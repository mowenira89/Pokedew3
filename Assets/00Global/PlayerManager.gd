extends Node

var player:Player
var equipped:Item
func set_player_ref(p:Player):
	player = p

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		var tile = TileManager.get_tile()
