class_name EntityData extends Resource


@export var hp:int
@export var max_hp:int
@export var energy:int
@export var max_energy:int
@export var happiness:int


var skills = {'farm':0,'mine':0,'forage':0,'perform':0,'cook':0,'craft':0,'fishing':0,'combat':0}
var skillIVs = {'farm':0,'mine':0,'forage':0,'perform':0,'cook':0,'craft':0,'fishing':0,'combat':0}
var skillEXPs = {'farm':0,'mine':0,'forage':0,'perform':0,'cook':0,'craft':0,'fishing':0,'combat':0}
var to_next_level = {'farm':0,'mine':0,'forage':0,'perform':0,'cook':0,'craft':0,'fishing':0,'combat':0}

@export var accuracy:int
@export var evasion:int
@export var crit:int
@export var work_speed:int

var liked_scents: Array[E.scents] = []
var liked_flavors:Array[E.flavors] = []
var liked_toys:Array[E.toys] = []
var liked_surroundings:Array[E.surroundings] = []
var liked_music:Array[E.music] = [] 

var disliked_scents: Array[E.scents] = []
var disliked_flavors:Array[E.flavors] = []
var disliked_toys:Array[E.toys] = []
var disliked_surroundings:Array[E.surroundings] = []
var disliked_music:Array[E.music] = [] 

var buffs = []
var inventory:Array[Item]
@export var produce:String

func get_base_stat(_stat:E.stats):
	match _stat:
		E.stats.Farm:_stat = skills["farm"]
		E.stats.Craft:_stat = skills["craft"]
		E.stats.Mine: _stat = skills["mine"]
		E.stats.Forage:_stat=skills['forage']
		E.stats.Perform:_stat=skills['perform']
		E.stats.Fishing:_stat=skills['fishing']
		E.stats.Cook:_stat = skills['cook']
		E.stats.Energy:_stat = max_energy
