class_name Entity extends CharacterBody2D

var data:EntityData
var species:String


func update_hp(d):
	data.hp+= clamp(d,0,data.max_hp)
	
