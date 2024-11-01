class_name ForagePoint extends Node

var forage
@export var forage_location:String



func set_forage():
	var table = LootTable.loot[forage_location]	
