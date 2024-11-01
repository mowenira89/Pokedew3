class_name ForageNode extends Node2D
@onready var timer: Timer = $Timer

var item:Item
@export var min_time:int=500
@export var max_time:int=1000
@export var forage_area:String

func _ready():
	get_loot()
	
func get_next_time():
	timer.start (randi_range(min_time,max_time))
	

func get_loot():
	if randi()%101>50:		
		item=Item.new()
		item.create_item(LootTable.get_loot(forage_area),1)
	else:
		get_next_time()

func _on_timer_timeout() -> void:
	get_loot()

func obtain_loot():
	pass
