extends CanvasLayer

@onready var hotbar = $VBoxContainer/HBoxContainer/Hotbar
@onready var inventory_ui = $ColorRect/InventoryUi
@onready var tool_inv_display = $VBoxContainer/HBoxContainer2/ToolInv
@onready var tool_display = $VBoxContainer/HBoxContainer/VBoxContainer/ToolDisplay
@onready var tool_icon = $VBoxContainer/HBoxContainer/VBoxContainer/ToolDisplay/TextureRect
@onready var message_box: VBoxContainer = $VBoxContainer/MessageContainer/MessageVBox

@onready var message = preload("res://Assets/Messages/overworld_message.tscn")

var hotbar_inv: Array[Item]
var inv: Array[Item]
@export var tool_inv:Array[Item]


var selected_index:int=9
var selected:Item
var tool_index:int=tool_inv.size()

var preview:TextureRect=null

func _ready():
	InvHelper.main_menu=self
	InvHelper.number_key_pressed.connect(set_choice)
	Signals.overworld_message.connect(display_message)
	
	var h = load("res://Assets/Resources/Inventories/hotbar.tres")
	hotbar_inv = h.inv
	var inv_res = load("res://Assets/Resources/Inventories/player_inventory.tres")
	inv = inv_res.inv
	
	#set inventories for InvUIs
	hotbar.inventory=hotbar_inv
	tool_inv_display.inventory = tool_inv
		
	var oran = Item.new()
	oran.create_item("berry-oran",5)
	InvHelper.add_inv_item(hotbar_inv,oran)
	var sapling = Item.new()
	sapling.create_item("sapling",1)
	InvHelper.add_inv_item(hotbar_inv,sapling)
	Signals.update_inventory.emit(hotbar_inv)

func _input(event):
	if event.is_action_pressed("Q"):
		open_toolbar()
		
	if event.is_action_pressed("MWU"):
		if InvHelper.scroll_mode=="hotbar":
			unselect_slots(hotbar)
			handle_choice(-1)
		if InvHelper.scroll_mode=="toolbar":
			unselect_slots(tool_inv_display)
			handle_tool_choice(-1)			
	if event.is_action_pressed("MWD"):
		if InvHelper.scroll_mode=="hotbar":
			unselect_slots(hotbar)
			handle_choice(1)	
		if InvHelper.scroll_mode=="toolbar":
			unselect_slots(tool_inv_display)
			handle_tool_choice(1)			
	
	
func set_choice(index):
	if index==-1:
		unselect_slots(hotbar)
		InvHelper.selected_item = tool_display.chosen_tool
		tool_display.background_color=Color("#41ff71")
		tool_display.queue_redraw()
	else:
		unselect_slots(hotbar)
		selected_index=index
		var slot = hotbar.get_child(index)	
		InvHelper.selected_item=slot.item
		slot.change_color('green')	
		
func handle_choice(change):
	selected_index+=change
	if selected_index>10:selected_index=0
	if selected_index<0:selected_index=10
	if selected_index==10:
		InvHelper.selected_item = tool_display.chosen_tool
		tool_display.background_color=Color("#41ff71")
		tool_display.queue_redraw()
	else:
		var slot = hotbar.get_child(selected_index)
		slot.change_color('green')
		InvHelper.selected_item = slot.item	

func handle_tool_choice(delta):
	tool_index+=delta
	if tool_index>tool_inv.size()-1:
		tool_index=0
	if tool_index<0:
		tool_index=tool_inv.size()-1
	var slot = tool_inv_display.get_child(tool_index)
	slot.change_color('green')
	selected=slot.item
	tool_display.chosen_tool=selected
	InvHelper.selected_item=selected
	tool_icon.texture = slot.icon.texture
	tool_icon.global_position=tool_display.global_position - Vector2(50,50)

func unselect_slots(inv:InvUI):
	for x in inv.get_children():
		x.change_color("orange")
		if inv==hotbar:
			tool_display.background_color=Color("#7402ff")
			tool_display.queue_redraw()
		
func open_toolbar():
	tool_inv_display.set_container(tool_inv)
	tool_inv_display.visible=!tool_inv_display.visible
	set_choice(-1)
	if tool_inv_display.visible:
		InvHelper.scroll_mode='toolbar'
		var slot = tool_inv_display.get_child(tool_index)
		slot.change_color('green')
	else:
		InvHelper.scroll_mode='hotbar'
		
func display_message(_message:String):
	var m = message.instantiate()
	message_box.add_child(m)
	m.write_message(_message)
	
