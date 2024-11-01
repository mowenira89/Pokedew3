class_name BreakableTree extends Breakable
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var canopy: Sprite2D = $Canopy
@onready var stump: Sprite2D = $Stump
@onready var loot_dropper: Node2D = $LootDropper

var stump_hp=3
var stage:int

@onready var collider = $CollisionShape2D
@onready var timer: Timer = $Timer
var growth_time = 10

func _ready():
	set_stage(5)

func set_stage(_stage:int):
	stage = _stage
	match stage:
		1:
			max_hp=1
			hp=1
			canopy.visible=false
			stump.frame=10
			collider.disabled=true
			tool_type = [Tool.tool_type.Hoe]
			timer.start(growth_time)
			stage=1
		2:
			max_hp=1
			hp=1
			canopy.visible=false
			stump.frame=9
			collider.disabled=true
			tool_type = [Tool.tool_type.Hoe]
			timer.start(growth_time)
			stage=2
		3:
			max_hp=4
			hp=4
			canopy.frame=2
			stump.frame=8
			canopy.visible=true
			collider.disabled=false
			tool_type = [Tool.tool_type.Axe]
			timer.start(growth_time)
			stage=3
		4:
			max_hp=7
			hp=7
			canopy.frame=1
			stump.frame=7
			canopy.visible=true
			collider.disabled=false
			tool_type = [Tool.tool_type.Axe]
			timer.start(growth_time)
			stage=4
		5:
			max_hp=9
			hp=9		
			canopy.frame=0
			stump.frame=6
			canopy.visible=true
			collider.disabled=false
			tool_type = [Tool.tool_type.Axe]
			timer.stop()
			stage=5
		6:
			max_hp=3
			hp=3
			canopy.visible=false
			timer.stop()
			stage=6

func break_breakable():
	if stage in [3,4,5]:
		anim.play("canopyfall")
		get_loot()
		
	else:
		get_loot()
		TileManager.covered_tiles.erase(tile)
		queue_free()
	


func get_loot():
	var wood_amount=0
	var sap_amount=0
	var acorn_amount=0
	match stage:
		1: acorn_amount=1
		2: acorn_amount=1
		3: wood_amount = 3
		4: 
			wood_amount = randi_range(3,max_hp+2)
			acorn_amount = randi_range(1,3)
			sap_amount = randi_range(1,4)
		5:
			wood_amount = randi_range(3,max_hp+2)
			acorn_amount = randi_range(1,3)
			sap_amount = randi_range(1,4)
		6: wood_amount = 2	
	for x in wood_amount:
		loot_dropper.drop_loot('wood')
	for x in sap_amount:
		loot_dropper.drop_loot('sap')
	for x in acorn_amount:
		loot_dropper.drop_loot('sapling')


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "canopyfall":
		canopy.queue_free()
		set_stage(6)


func _on_timer_timeout() -> void:
	if stage<5:stage+=1
	set_stage(stage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canopy.modulate="#ffffff80"


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canopy.modulate="#ffffffff"
