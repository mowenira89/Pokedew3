class_name BreakableStone extends Breakable

@onready var loot_dropper: LootDropper = $LootDropper
@onready var sprite: Sprite2D = $Sprite2D


func set_breakable(tile:Vector2i):
	super(tile)
	if sprite.frame in [0,1,2]:
		tool_type=[Tool.tool_type.Pickaxe]
		max_hp=3
		hp=3
	elif sprite.frame == 3:
		tool_type=[Tool.tool_type.Axe]
		max_hp=1
		hp=1
	elif sprite.frame==4:
		tool_type=[Tool.tool_type.Hoe,Tool.tool_type.Pickaxe,Tool.tool_type.Axe]
		max_hp=1
		hp=1
	
func get_loot():
	if sprite.frame in [0,1,2]: 
		var stone_amount = randi_range(1,3)
		var geode = randi()%100
		var coal = randi()%100
		for x in stone_amount:
			loot_dropper.drop_loot('stone')
		if geode>90: loot_dropper.drop_loot('geode')
		if coal<10:loot_dropper.drop_loot('coal')
	if sprite.frame == 3:
		loot_dropper.drop_loot('wood')		
	if sprite.frame == 4:
		loot_dropper.drop_loot('fiber')
