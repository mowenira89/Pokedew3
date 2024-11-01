class_name Stockpile extends Node2D

var inventory: Array[Item]=[]
@onready var inventory_ui: InvUI = $Control/Panel/InventoryUi

func _ready():
	pass
	#register self in stockpile manager
	inventory_ui.inventory = inventory
