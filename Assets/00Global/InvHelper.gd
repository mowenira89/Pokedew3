extends Node

var scroll_mode = "hotbar"
var main_menu
signal number_key_pressed(num:int)
var selected_item:Item
var held_item:Item=null
var preview:TextureRect
@onready var preview_item = preload("res://Assets/Shared/PreviewItem.tscn")
@onready var pickup = preload("res://Assets/Items/Pickup.tscn")

func _ready():
	Signals.item_right_clicked.connect(item_right_clicked)
	Signals.item_clicked.connect(item_clicked)



func add_inv_item(inv:Array[Item], item:Item)->bool:
	for i in inv:
		if i:
			if i.data.data_name == item.data.data_name and i.quantity<i.data.max_stack:
				if i.quantity+item.quantity<=i.data.max_stack:
					i.quantity+=item.quantity
				else:
					item.quantity-=(item.data.max_stack-i.quantity)
					i.quantity=i.data.max_stack
					
				Signals.update_inventory.emit(inv)
				return true
	for i in range(0,inv.size()):
		if inv[i]==null:
			inv[i]=item
			Signals.update_inventory.emit(inv)
			return true
	return false
		
	
func remove_inv_item(inv:Array[Item],item:Item,quantity:int):
	if item.quantity-quantity<0:return false
	item.quantity-=quantity
	if item.quantity<=0:
		var index = inv.find(item)
		inv[index]=null
	Signals.update_inventory.emit(inv)
	
		
		
func _unhandled_input(event):
	if event.is_action_pressed("`"):number_key_pressed.emit(-1)
	if event.is_action_pressed("1"):number_key_pressed.emit(0)
	if event.is_action_pressed("2"):number_key_pressed.emit(1)
	if event.is_action_pressed("3"):number_key_pressed.emit(2)
	if event.is_action_pressed("4"):number_key_pressed.emit(3)
	if event.is_action_pressed("5"):number_key_pressed.emit(4)
	if event.is_action_pressed("6"):number_key_pressed.emit(5)
	if event.is_action_pressed("7"):number_key_pressed.emit(6)
	if event.is_action_pressed("8"):number_key_pressed.emit(7)
	if event.is_action_pressed("9"):number_key_pressed.emit(8)
	if event.is_action_pressed("0"):number_key_pressed.emit(9)	

func create_preview(item:Item):
	var rect = preview_item.instantiate()
	rect.texture = load(item.data.texture)
	main_menu.add_child(rect)
	rect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	return rect



func item_clicked(_slot:InvSlot):
		
		if !held_item:
			if _slot.item==null:return
			held_item=_slot.item
			preview = create_preview(_slot.item)
			_slot.inventory[_slot.get_slot_index()]=null
			Signals.update_inventory.emit(_slot.inventory)
		else: 
			var target_index = _slot.get_slot_index()
			if _slot.item==null:
				_slot.inventory[target_index]=InvHelper.held_item
				end_preview()
				InvHelper.held_item=null
			else:
				if InvHelper.held_item.data.data_name==_slot.item.data.data_name:
					if held_item.quantity+_slot.item.quantity<=_slot.item.data.max_stack:
						_slot.item.quantity+=InvHelper.held_item.quantity
						end_preview()
						held_item=null
					else:
						held_item.quantity-=(held_item.data.max_stack-_slot.item.quantity)
						_slot.item.quantity=_slot.item.data.max_stack
					
				else:
					var new_held_item = _slot.item
					_slot.inventory[_slot.get_slot_index()]=held_item
					held_item=new_held_item
					if InvHelper.preview: InvHelper.preview.queue_free()
					InvHelper.preview=null
					InvHelper.preview=InvHelper.create_preview(_slot.item)		
			Signals.update_inventory.emit(_slot.inventory)


			

func end_preview():
	held_item=null
	if preview:preview.queue_free()
	preview=null



func item_right_clicked(_slot):
	if !held_item:
					
		var new_item_quantity=_slot.item.quantity/2
		if _slot.item.quantity%2==1:new_item_quantity+=1
		var n = _slot.item.data.data_name
		var new_item = Item.new()
		new_item.create_item(n,new_item_quantity)
		_slot.item.quantity-=new_item_quantity
		held_item=new_item
		preview = create_preview(new_item)
		preview.change_label(new_item_quantity)
			
		Signals.update_inventory.emit(_slot.inventory)
