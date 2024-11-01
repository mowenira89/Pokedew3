extends CharacterBody2D


var mon:IPokemon

var nearby_workables=[]
var nearby_foragables=[]
var task:E.likes = E.likes.Sleep
var set_task:E.likes

var work_rate
var can_water

var following=true
var next_forage_spot

@onready var hp = $HUD/HP
@onready var energy = $HUD/Energy
@onready var happiness = $HUD/Happiness
@onready var hud = $HUD
@onready var produce_timer = $ProduceTimer
@onready var options = $Options
@onready var inv = $Inv
@onready var tasks = $Options/Tasks
@onready var return_b = $Options/GridContainer/Return
@onready var task_b = $Options/GridContainer/Task
@onready var stats_b = $Options/GridContainer/Stats
@onready var inv_b = $Options/GridContainer/Inv
@onready var follow_b = $Options/GridContainer/Follow
@onready var work_timer = $WorkTimer


func set_mon(mon:IPokemon):
	self.mon = mon
	
func _ready():
	$Mon.texture = load("res://Assets/Sprites/Pokemon/"+mon.species+".png")
	check_watering()
	set_bars()
	input_pickable=true
	Global.update_inventory.connect(set_inv)
	
func _physics_process(delta):
	if following:
		if global_position.distance_to(Global.player_ref.global_position)>100:
			velocity = global_position.direction_to(Global.player_ref.global_position) * 100
			move_and_slide()
	if task==E.likes.Forage and next_forage_spot!=null and !following:
		if global_position.distance_to(next_forage_spot.global_position)>10:
			velocity = global_position.direction_to(next_forage_spot.global_position) * 100
			move_and_slide()


func set_bars():
	hp.max_value = mon.max_health
	energy.max_value = mon.get_stat(E.stats.Energy)
	happiness.max_value = 255
	happiness.value = mon.happiness
	energy.value = mon.current_energy
	hp.value = mon.current_hp
	
func _process(delta):
	if is_instance_of(mon,IPokemon):
		hp.value = mon.current_hp
		energy.value = mon.current_energy
		happiness.value = mon.happiness
	
func check_watering():
	for move in mon.moves:
		if Moves.moves[move]['type']=='water': 
			can_water=true
			return	
	can_water=false
	

func _on_work_area_body_entered(body):
	if body.is_in_group("Workable"):
		nearby_workables.append(body)
	if body.is_in_group('Foragable'):
		nearby_foragables.append(body)


func _on_work_area_body_exited(body):
	if body in nearby_workables:
		nearby_workables.erase(body)



func do_task(_task:E.likes):
	task = _task
	set_task = _task

	var work_base = mon.get_stat(E.stats.WorkSpeed)
	if task in mon.likes: work_base+=50
	if work_base>370:work_rate=2 
	elif work_base>340:work_rate=4 
	elif work_base>300:work_rate=5
	elif work_base>250:work_rate=6
	else: work_rate=8
	$WorkTimer.start(1)


func get_workspeed():
	var work_base = mon.get_stat(E.stats.WorkSpeed)
	if task in mon.likes: work_base+=50
	if work_base>370:work_rate=2 
	elif work_base>340:work_rate=4 
	elif work_base>300:work_rate=5
	elif work_base>250:work_rate=6
	else: work_rate=8

func _on_work_timer_timeout():
	flash_collider()
	if mon.happiness>15 and mon.current_energy > 5:
		task = set_task
		$WorkTimer.stop()
		match task:
			E.likes.Farm:
				farm()		
			E.likes.Sleep:
				rest()
			E.likes.Forage:
				forage()
		get_workspeed()
		$WorkTimer.start(work_rate)
	else: 
		mon.task = E.likes.Sleep
		rest()
		work_timer.start(30)	
		
		
		
@onready var work_collider = $WorkArea/CollisionShape2D
	
func flash_collider():
	work_collider.disabled=true
	work_collider.disabled=false
	
func farm():
	
	var farm_stat = mon.get_stat(E.stats.Farm)
	if E.likes.Farm in mon.likes:
		mon.increase_happiness(2)
		mon.increase_energy(-2)
	else:
		mon.increase_happiness(-1)
		mon.increase_energy(-4)
	check_watering()
	for x in nearby_workables:
		if x.is_in_group("Crop"):
			if E.likes.Farm in mon.likes:
				x.love+=farm_stat*2
				mon.get_exp(E.skills.Farm,4)
			else: 
				x.love+=farm_stat/2
				mon.get_exp(E.skills.Farm,2)
			if x.pest!=null:
				if fight_pest(x.pest)==1:x.remove_pest()
				else: x.take_damage(1)
			if x.water<10 and can_water:
				x.get_watered()
			$work_pause.start(2)
			await $work_pause.timeout
			
func forage():
	next_forage_spot=nearby_foragables.pick_random()
	if E.likes.Forage in mon.likes: 
		mon.increase_energy(-2)
		mon.increase_happiness(4)
	else: 
		mon.increase_energy(-4)
		mon.increase_happiness(-1)
	var forage_skill = mon.get_stat(E.stats.Forage)
	var r = randi()%255 - forage_skill
	if r<forage_skill:
		next_forage_spot.collect_loot(mon)

		
func rest():
	mon.increase_energy(10)
	mon.increase_health(10)
	mon.increase_happiness(5)
	if E.likes.Sleep in mon.likes: mon.increase_happiness(10)
	for x in mon.inventory:
		if x!=null:
			if x.data.type==Item.its.Book:
				read(x)
			
func fight_pest(pest):
	var tender_attack = mon.get_stat(E.stats.Attack) + mon.get_stat(E.stats.SpA) + mon.get_stat(E.stats.Speed)  
	var pest_defense = pest.get_stat(E.stats.Attack) + pest.get_stat(E.stats.SpA) + pest.get_stat(E.stats.Speed)
	if tender_attack > pest_defense:
		return 1
	else: return 0

func _on_mouse_entered():
	hud.visible=true
	

func _on_mouse_exited():
	hud.visible=false

func set_inv():
	for x in inv.get_children(): x.queue_free()
	for i in mon.inventory:
		var new = Global.inv_slot.instantiate()
		inv.add_child(new)
		new.set_locations(mon.inventory, get_parent())
		if i!=null: new.set_item(i)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_released():
		if event.button_index==1:
			pass
		if event.button_index==2:
			open_options()


func open_options():
	options.visible = !options.visible
	if following == true:
		follow_b.text = "Stay"
	else: follow_b.text = "Follow"



func _on_task_pressed():
	tasks.visible = !tasks.visible

func close_options():
	tasks.visible=false
	options.visible=false
	
func _on_farm_pressed():
	do_task(E.likes.Farm)
	close_options()

func _on_rest_pressed():
	do_task(E.likes.Sleep)
	close_options()
	
func _on_forage_pressed():
	do_task(E.likes.Forage)
	close_options()
	

func _on_dig_pressed():
	do_task(E.likes.Mine)
	close_options()


func _on_follow_pressed():
	following = !following
	open_options()


func _on_return_pressed():
	mon.location="ball"
	queue_free()

func read(book:Item):
	var r = randi()%255
	if r>230:
		mon.skillEVs[E.like_to_skill(book.data.subject)]+=1
	if r>250:
		mon.add_like(book.data.subject)
	if book.data.subject in mon.likes: mon.increase_happiness(book.data.happiness_restored)
	for x in mon.likes:
		if x in book.data.keywords: mon.increase_happiness(15)
	if E.likes.Reading in mon.likes: mon.increase_happiness(book.data.happiness_restored)


func _on_inv_pressed():
	inv.visible = !inv.visible
	set_inv()
