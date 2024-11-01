extends Node

var num=0
var stockpiles = {}

func add_stockpile(stockpile:Stockpile):
	stockpiles["stockpile"+str(num)]=stockpile
	num+=1
