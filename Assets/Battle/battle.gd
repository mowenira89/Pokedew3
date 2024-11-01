extends CanvasLayer
class_name Battle

var player_pokemon:IPokemon
var enemy:IPokemon

@onready var opponent_sprite = $TextureRect/GUI/Opponent
@onready var player_sprite = $TextureRect/GUI/PlayerPkmn
@onready var hp = $TextureRect/GUI/HP
@onready var exp = $TextureRect/GUI/EXP
@onready var opponent_hp = $TextureRect/GUI/OpponentHP
@onready var player_name = $TextureRect/GUI/Name
@onready var opponent_name = $TextureRect/GUI/OpponentName
@onready var anim = $AnimationPlayer
@onready var moves_container = $TextureRect/GUI/Moves/GridContainer
@onready var commands = $TextureRect/GUI/Commands
@onready var moves_container_container = $TextureRect/GUI/Moves
@onready var message = $Message
@onready var pkmn_screen = $PKMNScreen
@onready var inventory = $Inventory
@onready var naming = $NamingWindow
@onready var thrown_item = $TextureRect/GUI/ThrownItem

var last_player_move
var player_move_for_turns=1
var last_enemy_move
var enemy_move_for_turns=1

var turn="player"

func start_battle(enemy:IPokemon):
	self.enemy = enemy
	
	player_pokemon = Global.player_pokemon[0]
	anim.play("transition")
	set_player()
	set_opponent()
	message.add_message("A wild "+enemy.nickname+" appears!")
	message.display_message()
	await message.messages_done
	start_turn()

func _ready():
	Global.set_battle_ref(self)
	Global.swap_clicked_in_battle.connect(swap_mons)
	naming.rename_complete.connect(end_battle)
	Global.pokeball_go_in_battle.connect(throw_pokeball)
	
func set_opponent():
	opponent_sprite.texture = load(enemy.texture)
	opponent_sprite.flip_h=true
	opponent_name = enemy.nickname + "   lvl."+str(enemy.level)
	opponent_hp.max_value=enemy.max_health
	opponent_hp.value = enemy.current_hp
	enemy.turns_poisoned=0

func set_player():
	await get_tree().create_timer(1).timeout
	anim.play("enter")
	player_sprite.texture=load(player_pokemon.texture)
	player_name = player_pokemon.nickname + "   lvl."+str(player_pokemon.level)
	hp.max_value = player_pokemon.max_health
	hp.value = player_pokemon.current_hp 
	player_pokemon.turns_poisoned=0

func set_health():
	hp.max_value = player_pokemon.get_stat(E.stats.HP)
	hp.value = player_pokemon.current_hp 
	opponent_hp.max_value=enemy.get_stat(E.stats.HP)
	opponent_hp.value = enemy.current_hp

func swap_mons(mon):
	anim.play("shrink")
	player_pokemon=mon
	set_player()
	$PKMNScreen.visible=false
	

func _on_run_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		end_battle()

func end_battle():
	Global.control = E.control.MOVE
	for x in player_pokemon.buffs:
		if x.type == Buff.types.Battle:
			player_pokemon.buffs.erase(x)
	queue_free()

func start_turn():
	commands.visible = true
	var buffed_char = [player_pokemon.buffs, enemy.buffs]
	for x in buffed_char:
		for buff in x:
			if buff.has("turns"):
				buff.turns-=1
				if buff.turns<=0:
					buff.remove(x)

signal move_button

func _on_fight_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		commands.visible = false
		for x in $TextureRect/GUI/Moves/GridContainer.get_children():
			x.queue_free()
		moves_container_container.visible = true
		
		for move in player_pokemon.moves:
			var b = Button.new()
			b.text = move
			b.pressed.connect(Callable(get_priority).bind(move))
			moves_container.add_child(b)

func get_priority(move):
	moves_container_container.visible=false
	var enemy_move
	if player_pokemon.encore:
		move = last_player_move	
	if enemy.encore:
		enemy_move = last_enemy_move
	else: enemy_move = enemy.moves.pick_random()		
	

	var p_priority = Moves.moves[move]['priority']
	var e_priority = Moves.moves[enemy_move]['priority']
	var turn_order = []
	if p_priority == e_priority:
		if player_pokemon.get_stat(E.stats.Speed) >= enemy.get_stat(E.stats.Speed):
			turn_order= [player_pokemon,enemy]
		else: turn_order= [enemy,player_pokemon]
	elif p_priority>e_priority:
		turn_order= [player_pokemon,enemy]
	else: turn_order= [enemy,player_pokemon]
	for x in turn_order:
		if x==enemy:
			play_turn(enemy, player_pokemon, enemy_move)
			message.display_message()
			await message.messages_done
			end_turn(enemy)
		else: 
			play_turn(player_pokemon, enemy, move)
			message.display_message()
			await message.messages_done
			end_turn(player_pokemon)
	start_turn()



func play_turn(attacker:IPokemon, defender:IPokemon, move=null):
	
	if move==null:
		move=attacker.moves.pick_random()
	if !attacker.flinch:
		if E.statuses.SLEEP in attacker.status:
			message.add_message(attacker.nickname+" is fast asleep!")
			return
		else:
			if E.statuses.PRLZ in attacker.status:
				if randi()%100 > 50:
					message.add_message(attacker.nickname+" is paralized and cannot attack!")
					return
			else:
					message.add_message(attacker.nickname+" used " + move)
					if E.statuses.CONF in attacker.status:
						message.add_message(attacker.nickname +" is confused!")
						message.display_message()
						await message.messages_done
						if randi()%100>50:
							if randi()%100>50: 
								move = attacker.moves.pick_random()
								message.add_message(attacker.nickname+" used " + move +" instead!")
							else:
								attacker.current_hp-=attacker.get_stat(E.stats.HP)*0.0625
								message.add_message(attacker.nickname+" hurt itself instead!")
								return
					else:			
						if accuracy_check(attacker, defender, move, E.stats.Acc)==0:
							message.add_message(attacker.nickname+"'s attack missed!")
							message.display_message()
							await message.messages_done
							return
						else:
							if accuracy_check(defender,attacker,move,E.stats.Evasion)==0:
								message.add_message(defender.nickname+" evaded the attack!")
								message.display_message()
								await message.messages_done
								return
							else:
								var damage = get_damage(attacker, defender, move)
								if damage[1]>1:
									message.add_message("Critical Hit!")
								if damage[2]>1:
									message.add_message("It's super effective!")
								if damage[2]<1:
									message.add_message("It's not very effective...")
								defender.current_hp-=damage[0]
								set_health()										
		
func accuracy_check(attacker:IPokemon, evader:IPokemon, move, stat:E.stats):
	var modded_acc = Moves.moves[move]['acc']*attacker.get_stat(E.stats.Acc)
	if randi()%101 <= modded_acc: return 1
	else: return 0
		

	
		
func get_damage(user:IPokemon, target:IPokemon, move_name):
	var A
	var D
	var move = Moves.moves[move_name]
	var power = move['power']
	if move['damage_class']=='physical': 
		A = user.get_stat(E.stats.Attack) 
		D = target.get_stat(E.stats.Def)
	else: 
		A = user.get_stat(E.stats.SpA)
		D = user.get_stat(E.stats.SpD)
			
	var damage = ((((2*user.level)/5+2)*power*(A/D)/50)+2)
	var stab = 1
	var crit = 1
	var type_effectiveness:float = 1.0
	var burn = .4 if E.statuses.BRN in user.status else 1
	#STAB and CRIT
	if move['type'] in user.types:stab=1.5
	if randi()%255>user.get_stat(E.stats.Crit):crit=1.5
	#Type Effectiveness
	for x in target.types:
		if move['type'] in Types.weaknesses[x]:
			type_effectiveness*=2
		if move['type'] in Types.resist[x]:
			type_effectiveness/=2
		
	damage*=stab
	damage*=crit
	damage*=burn
	damage*=type_effectiveness
	return [damage,crit,type_effectiveness]
	
func end_turn(turn_ender:IPokemon):
	if E.statuses.BRN in turn_ender.status:
		var burn_damage = turn_ender.max_health*0.0625
		turn_ender.current_hp-=burn_damage
		set_health()
		message.add_message(turn_ender.nickname+" was hurt by its burn!")
	if E.statuses.TOXIC in turn_ender.status:
		turn_ender.turns_poisoned+=1
		var psn_damage = (turn_ender.max_health*0.0625)*turn_ender.turns_poisoned	
		turn_ender.current_hp-=psn_damage
	if E.statuses.PSN in turn_ender.status:
		var psn_damage = turn_ender.max_health&0.0625
		turn_ender.current-=psn_damage
		set_health()
		message.add_message(turn_ender.nickname+" was hurt by poison!")
	if message.messages.size()>=1: 
		message.display_message()
		await message.messages_done


func _on_pkmn_pressed():
	pkmn_screen.set_screen()
	pkmn_screen.visible=true

func _on_bag_pressed():
	inventory.set_bag()
	inventory.visible=true

func use_item(item:Item):
	inventory.visible=false
	if item.data.type==Item.its.Pokeball:
		throw_pokeball(item)
		
		
func throw_pokeball(item:Item):
	inventory.visible=false
	thrown_item.texture = load(item.texture)
	anim.play("throw")
	anim.play("enemy_shrink")
	var rate = Pokemon.pkmn[enemy.species]["capture_rate"]*item.data.catch_rate
	var a = ceil((((3*enemy.hadsads[0])-(2*enemy.current_hp))*rate)/3*enemy.hadsads[0])
	var catch = randi_range(1,255)
	print("a: "+ str(a))
	print("catch: "+str(catch))
	if catch<=a:
		message.add_message(enemy.nickname+" was caught!")
		message.display_message()
		await message.messages_done
		enemy.be_caught()
		naming.set_pkmn(enemy)
		naming.visible=true
	else:
		anim.play("enemy_appear")
		message.add_message(enemy.nickname+" escaped capture!")
		message.display_message()
		opponent_sprite.scale=Vector2i(3,3)
		thrown_item.visible=false
