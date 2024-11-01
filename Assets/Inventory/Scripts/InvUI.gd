class_name InvUI extends GridContainer

@export var inventory:Array[Item]
@onready var slot = preload("res://Assets/Inventory/inv_slot.tscn")

var holding:InvSlot
var first_slot:InvSlot

func _ready():
	Signals.update_inventory.connect(set_container)

func _process(delta):
	if InvHelper.preview:
		InvHelper.preview.global_position=get_global_mouse_position()

func set_container(inv=inventory):
	
	if inv == inventory:
		for x in get_children():
			x.queue_free()
		for i in inventory:
			var new_slot = slot.instantiate()
			add_child(new_slot)
			if i!=null:
				new_slot.set_slot(i)
			new_slot.inventory = inv

			
