class_name Buff extends Resource

enum types{Permanent,Battle,TurnBased,Timed,Equiped,Recharge}

var stat:E.stats
var amount:int
var method:String
var owner:Entity
var type:types


func create_buff(s:E.stats,a:int,t:Entity,m:String="a"):
	stat = s
	amount = a
	method=m
	owner = t
	#get name
	#add to owner buff list
	
func apply():
	var s = owner.get_base_stat(stat)
	if method=="p+":
		return s*amount
	if method=="p-":
		return s*amount*-1
	else: 
		return amount 
	
func remove():
	pass	
