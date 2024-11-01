class_name InvSlot extends ColorRect

@onready var icon = $ColorRect/Icon
@onready var quantity = $ColorRect/Quantity
@onready var border = $"."
@onready var label = $Label
var inventory:Array[Item]

var item:Item

func set_slot(i:Item):
	item = i
	quantity.text = str(item.quantity)
	label.text=item.data.name
	if item.quantity>1:quantity.visible=true
	else:quantity.visible=false
	icon.texture = load("res://Assets/Sprites/Items/"+item.data.data_name+".png")
	
func get_slot_index()->int:
	return get_parent().get_children().find(self)
	
func change_color(color:String):
	if color=="orange": border.color = Color("#ff7771")
	if color=="green": border.color = Color("#41ff71")


func _on_mouse_entered():
	if item!=null:
		label.visible=true


func _on_mouse_exited():
	label.visible=false


func _on_icon_mouse_entered():
	if item!=null:
		label.visible=true


func _on_icon_mouse_exited():
	label.visible=false



func _on_icon_gui_input(event):
	if event is InputEventMouseButton and event.button_index==1 and event.is_pressed():
		Signals.item_clicked.emit(self)	
	if event is InputEventMouseButton and event.button_index==2 and event.is_pressed():	
		Signals.item_right_clicked.emit(self)
