class_name BreakableTree2 extends Breakable
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var canopy: Sprite2D = $Canopy
@onready var stump: Sprite2D = $Stump
@onready var timer: Timer = $Timer
@onready var collider:CollisionShape2D = $CollisionShape2D
var growth_time=10
var stump_hp=3
var stage:int
var is_stump=false
@export var species:trees
@onready var loot_dropper: LootDropper = $LootDropper

enum trees{Basic,Apricorn,Honey,Headbutt}

func _ready():
	set_stage(5)

func set_stage(_stage:int):
	stage = _stage
	match stage:
		1:
			max_hp=1
			hp=1
			canopy.visible=false
			stump.frame=3
			is_stump=true
			timer.start(growth_time)
			tool_type=[Tool.tool_type.Hoe]
			collider.disabled=true
			stage=1
		2:
			max_hp=1
			hp=1
			stump.frame=2
			canopy.visible=false
			is_stump=true
			timer.start(growth_time)
			collider.disabled=true
			tool_type=[Tool.tool_type.Hoe]
			stage=2
		3:
			max_hp=1
			hp=1
			stump.frame=1
			is_stump=true
			timer.start(growth_time)
			collider.disabled=false
			tool_type=[Tool.tool_type.Axe,Tool.tool_type.Hoe]
			stage=3
		4:
			max_hp=3
			hp=3
			stump.frame=0
			is_stump=true
			tool_type=[Tool.tool_type.Axe]
			timer.start(growth_time)
			stage=4
		5: 
			max_hp=7
			hp=7
			stump.frame=4
			canopy.visible=true
			is_stump=false
			tool_type=[Tool.tool_type.Axe]
			timer.stop()
			stage=5
		6:
			max_hp=3
			hp=3
			stump.frame=4
			canopy.visible=false
			is_stump=true
			tool_type=[Tool.tool_type.Axe]
			stage=6

func break_breakable():
	if stage==5:
		anim.play("canopyfall")
	get_loot()
	if stage==6:
		TileManager.covered_tiles.erase(tile)
		queue_free()
	



func get_loot():
	var wood_amount=0
	var sap_amount=0
	var acorn_amount=0
	match stage:
		1: acorn_amount=1
		2: acorn_amount=1
		3: wood_amount = 1
		4: wood_amount = randi_range(1,3)
		5:
			wood_amount = randi_range(3,max_hp+2)
			acorn_amount = randi_range(1,3)
			sap_amount = randi_range(1,4)
		6: wood_amount = 2	
	for x in wood_amount:
		loot_dropper._loot('wood')
	for x in sap_amount:
		loot_dropper.drop_loot('sap')
	for x in acorn_amount:
		loot_dropper.drop_loot('acorn')
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "canopyfall":
		set_stage(6)
		canopy.rotation=0


func _on_timer_timeout() -> void:
	if stage<5: stage+=1
	set_stage(stage)
