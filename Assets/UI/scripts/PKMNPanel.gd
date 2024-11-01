extends Control

var mon:IPokemon
signal options_opened(panel)

@onready var image = $Border/ColorRect/Image
@onready var _name = $Border/ColorRect/VBoxContainer/HBoxContainer/Name
@onready var lvl = $Border/ColorRect/VBoxContainer/HBoxContainer/LVL
@onready var hp = $Border/ColorRect/VBoxContainer/HP
@onready var happiness = $Border/ColorRect/VBoxContainer/Happiness
@onready var exp = $Border/ColorRect/VBoxContainer/Exp
@onready var options = $Options
@onready var go = $Options/ColorRect/GridContainer/Go
var battle=false

func set_mon(mon:IPokemon):
	self.mon = mon


func _ready():
	image.texture = load("res://Assets/Sprites/Pokemon/"+mon.species+".png")
	_name.text = mon.nickname
	lvl.text = "    "+str(mon.level)
	hp.max_value=mon.get_stat(E.stats.HP)
	hp.value = mon.current_hp
	exp.max_value=mon.xp_to_next_lvl
	exp.value = mon.xp
	happiness.max_value = mon.max_happiness
	happiness.value = mon.happiness	
	
	if mon.location=='field': go.text = "Return!"
	else: go.text="Go!"


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_released():
		options_opened.emit(self)

func _on_go_pressed():
	if battle:
		Signals.swap_clicked_in_battle.emit(mon)
	else:
		if mon.location=="ball":
			Signals.pkmn_go.emit(mon)
		

func _on_stat_pressed():
	Signals.stat_clicked.emit(mon)



func _on_swap_pressed():
	if battle:
		print('swap')		
		Signals.swap_clicked_in_battle.emit(mon)
