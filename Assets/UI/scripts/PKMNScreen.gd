extends ColorRect

@export var setting:String
var panels = preload("res://Assets/UI/Scripts/PKMNPanel.gd")
@onready var panelcontainer = $HBoxContainer/MarginContainer/PKMNPanels
@onready var stat_screen = $HBoxContainer/StatScreen

func _ready():
	Global.Stat_Clicked.connect(set_stat_screen)

func set_stat_screen(mon):
	stat_screen.set_mon(mon)
	stat_screen.visible = true

func clear():
	for x in panelcontainer.get_children():
		panelcontainer.remove_child(x)
		x.queue_free()
	

func set_screen():
	clear()
	for x in Global.player_pokemon:
		var panel = panels.instantiate()
		panel.set_mon(x)
		if setting=='Battle':
			panel.battle=true
		panel.options_opened.connect(close_options)
		panelcontainer.add_child(panel)
		
func close_options(panel):
	if panel.options.visible: panel.options.visible=false
	else:
		for x in panelcontainer.get_children():
			x.options.visible=false
		panel.options.visible = true


func _on_texture_button_pressed():
	visible=false
