class_name LootTable extends Resource

const loot = {
	'mushroom-forage':{'mushroom-tiny':60,'mushroom-big':10,'mushroom-balm':1,'mushroom-red':30, 'mushroom-morel':10, 'mushroom-common':60,'mushroom-chanterelle':5},
	'tree-forage':{'cool-stick':20,'acorn':50,'sapling':50}
}

static func get_loot(area:String)->String:
	var total=0
	var list_of_loot=[]
	for x in loot[area]:
		total+=loot[x]
		list_of_loot.append(x)
	while total>0:
		var picked_loot = list_of_loot.pop_at(randi()%list_of_loot.size())
		total-=loot[area][picked_loot]
		if total<=0:
			return picked_loot
	return 'failed'
