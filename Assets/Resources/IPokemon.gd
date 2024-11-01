extends EntityData
class_name IPokemon

enum nats {Hardy, Lonely, Brave, Adamant, Naughty, Bold,Docile,Relaxed,Impish,Lax,Timid,Hasty,Serious,Jolly,Naive,Modest,Mild,Quiet,Bashful,Rash,Calm,Gentle,Sassy,Careful,Quirky}


@export var species:String
@export var level = 1
var ivs = [0,0,0,0,0,0]
var evs = [0,0,0,0,0,0]
var hadsads = [0,0,0,0,0,0]
var status = []
var xp = 0
var xp_to_next_lvl = 1

var species_data: get = get_species_data
var types: get = get_types

func get_types():
	return Pokemon.pkmn[species]["types"]

func get_species_data():
	return Pokemon.pkmn[species]

var nickname = species
var nature = nats
var ability = null

var previous_likes = []

var task

var moves = []
var learned_moves = []

var location = "Field"
var texture:String
var wild = true


var flinch=false
var confusion=false
var cursed = false
var toxic = false 
var protected = false
var turns_poisoned = 0
var encore = false

func _init(species, lvl):
	level = lvl
	self.species = species
	self.nickname = species
	texture="res://Assets/Sprites/Pokemon/"+species+".png"
	
	#set naure
	var natures = []
	for n in nats:natures.append(n)
	nature = natures.pick_random()
	#set ivs
	for i in range(0,6):
		ivs[i] = randi_range(0,32)
	for i in skillIVs:
		skillIVs[i]=randi_range(0,3)
	#set_stats	
	happiness = 100
	set_stats()
	set_skills()
	hp=get_stat(stats.HP)
	energy = get_stat(stats.Energy)
	set_likes()
	inventory.resize(get_stat(stats.InvSize))
	moves = set_moves()	
	set_ability()
	inventory.resize(species_data['inv'])
	
	
	
func set_stats():
	var base = species_data['hadsads']
	var health = floor(((2*base[0]+ivs[0]+(evs[0]/4))*level)/100)+level+10	
	hadsads[0]=health
	for i in range(1,6):
		hadsads[i]=floor((floor((2*base[i]+ivs[i]+(evs[i]/4))*level)/100)+5)
	max_energy = ((get_stat(stats.Speed)+get_stat(stats.HP))/2)

func set_skills():
	for x in skills:
		var species_skill = species_data['species_skills'][x]
		species_skill+=skillIVs[x]
		skills[x] = species_skill

	
func set_nature_buff():	
	var buff = Buff.new()
	buff.amount=1.1
	buff.method="m"
	buff.type = Buff.types.Permanent
	
	var debuff = Buff.new()
	debuff.amount=.9
	debuff.method="m"
	debuff.type = Buff.types.Permanent
	
	match self.nature:
		nats.Lonely:
			buff.stat=E.stats.Attk
			debuff.stat = E.stats.Def	
		nats.Brave:
			buff.stat=E.stats.Attk
			debuff.stat=E.stats.Speed
		nats.Adamant:
			buff.stat=E.stats.Attk
			debuff.stat=E.stats.SpA
		nats.Naughty:
			buff.stat=E.stats.Attk
			debuff.stat=E.stats.SpD
		nats.Bold:
			buff.stat=E.stats.Def
			debuff.stat=E.stats.Attk
		nats.Relaxed:
			buff.stat=E.stats.Def
			debuff.stat=E.stats.Speed
		nats.Impish:
			buff.stat=E.stats.Def
			debuff.stat=E.stats.SpA
		nats.Lax:
			buff.stat=E.stats.Def
			debuff.stat=E.stats.SpD
		nats.Timid:
			buff.stat=E.stats.Speed
			debuff.stat=E.stats.Attk
		nats.Hasty:
			buff.stat=E.stats.Speed
			debuff.stat=E.stats.Def
		nats.Jolly:
			buff.stat=E.stats.Speed
			debuff.stat=E.stats.SpA
		nats.Naive:
			buff.stat=E.stats.Speed
			debuff.stat=E.stats.SpD
		nats.Modest:
			buff.stat=E.stats.SpA
			debuff.stat=E.stats.Attk
		nats.Mild:
			buff.stat=E.stats.SpA
			debuff.stat=E.stats.Def
		nats.Quiet:
			buff.stat=E.stats.SpA
			debuff.stat=E.stats.Speed
		nats.Rash:
			buff.stat=E.stats.SpA
			debuff.stat=E.stats.SpD
		nats.Calm:
			buff.stat=E.stats.SpD
			debuff.stat=E.stats.Attk
		nats.Gentle:
			buff.stat=E.stats.SpD
			debuff.stat=E.stats.Def
		nats.Sassy:
			buff.stat=E.stats.SpD
			debuff.stat=E.stats.Speed
		nats.Careful:
			buff.stat=E.stats.SpD
			debuff.stat=E.stats.SpA
	
	buffs.append(buff)
	buffs.append(debuff)
	
		
func set_likes():
	match self.nature:
		nats.Hardy or nats.Lonely or nats.Brave or nats.Adamant or nats.Naughty:
			add_like(E.flavors.Spicy)
		nats.Bold or nats.Docile or nats.Relaxed or nats.Impish or nats.Lax:
			add_like(E.flavors.Sour)
		nats.Timid or nats.Hasty or nats.Serious or nats.Jolly or nats.Naive: 
			add_like(E.flavors.Sweet)
		nats.Modest or nats.Mild or nats.Quiet or nats.Bashful or nats.Rash:
			add_like(E.flavors.Dry)
		nats.Calm or nats.Gentle or nats.Sassy or nats.Careful or nats.Quirky:
			add_like(E.flavors.Bitter)
	for t in Pokemon.pkmn[species]["types"]:
		match t:
			'grass':if randi()%100 < 90: add_like(E.surroundings.Foliage)
			'fire':if randi()%100 < 90: add_like(E.surroundings.Fire)
			'water':if randi()%100 < 90: add_like(E.surroundings.Water)
			'dark':if randi()%100 < 90: add_like(E.surroundings.Dark)
			'ghost':if randi()%100 < 70: add_like(E.surroundings.Macabre)
			'psychic':
				if randi()%100 < 80: add_like(E.activities.Meditation)
				if randi()%100 < 40: add_like(E.activities.Reading)
			'fight':
				if randi()%100 < 90: add_like(E.activities.Fight)
				if randi()%100 < 40: add_like(E.activities.Craft)
		for l in species_data['species_likes']:
			if randi()%100 < species_data['species_likes'][l]:
				add_like(l)
	

func add_like(like):
	if like is E.flavors:
		if like not in liked_flavors: liked_flavors.append(like)
	elif like is E.music:
		if like not in liked_music: liked_music.append(like)
	elif like is E.scents:
		if like not in liked_scents: liked_scents.append(like)
	elif like is E.surroundings:
		if like not in liked_surroundings: liked_surroundings.append(like)
	elif like is E.toys:
		if like not in liked_toys: liked_toys.append(like)
	
func add_move(move):
	if move not in moves: moves.append(move)
	if move not in learned_moves: learned_moves.append(move)
	
func set_moves():
	var learnset = species_data['learnset']
	var current_moves = []
	for i in learnset:
		if i <= level:	
			if learnset[i].contains(","):
				var moves = learnset[i].split(',')
				for x in moves:
					current_moves.append(x)
			else:
				current_moves.append(learnset[i])	
	var moves = []
	if current_moves.size() > 4: 
		while moves.size()<4:	
			var r = current_moves.pick_random()
			if r not in moves:moves.append(r)
	else: moves = current_moves
	return moves
	

func set_ability():
	var ability = species_data['abilities'].pick_random()
	

func get_base_stat(stat):
	var _stat
	match stat:
		E.stats.HP: _stat=hadsads[0]
		E.stats.Attk: _stat=hadsads[1]
		E.stats.Def: _stat=hadsads[2]
		E.stats.SpA: _stat=hadsads[3]
		E.stats.SpD: _stat=hadsads[4]
		E.stats.Speed:_stat=hadsads[5]
		E.stats.Accuracy:_stat=100
		E.stats.Evasion:_stat=100
		E.stats.Crit:_stat=220
		E.stats.Farm:_stat = skills["farm"]
		E.stats.Craft:_stat = skills["craft"]
		E.stats.Mine: _stat = skills["mine"]
		E.stats.Forage:_stat=skills['forage']
		E.stats.Perform:_stat=skills['perform']
		E.stats.Fishing:_stat=skills['fishing']
		E.stats.Cook:_stat = skills['cook']
		E.stats.InvSize:_stat = species_data['inv']			
		E.stats.Energy:_stat = max_energy
		E.stats.WorkSpeed:_stat = get_stat(E.stats.Speed)+happiness
	return _stat

enum stats {HP,Attack,Def,SpA,SpD,Speed,Accuracy,Evasion,Crit,Farm,Mine,Craft,Forage,Cook,Fishing,Perform,InvSize,WorkSpeed,Energy}
func get_stat(stat:E.stats):
	var _stat = get_base_stat(stat)
	
	var total_buff:int
	for buff in buffs:
		if buff.stat==stat:
			total_buff += buff.apply(_stat)
	_stat+=total_buff
	return _stat	


func get_next_level_amount(stat):
	var base = 50 * skills[stat]
	match stat:
		"farm":
			if 'grass' in types: base/=2	
		"craft":
			if 'psychic' in types or 'fighting' in types: base/=2
		"mine":
			if 'rock' in types or 'ground' in types: base/=2
		"cook":
			if 'fire' in types:base/=2
		"combat":
			if 'fighting' in types: base/2
	to_next_level[stat]=base
			
func get_exp(stat:String, amount):
	skillEXPs[stat]+=amount
	if skillEXPs[stat]>=to_next_level[stat]:
		skills[stat]+=1
		get_next_level_amount(stat)
