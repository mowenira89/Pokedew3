class_name Player extends Entity

var cardinal_direction:Vector2=Vector2.DOWN
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2
const DIR_4 = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]
@onready var sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
var auto_aiming=true


func _ready():
	PlayerManager.set_player_ref(self)
	state_machine.initialize()
	data 

func _process(delta):
	direction = Vector2(
		Input.get_axis("left",'right'),
		Input.get_axis("up","down")
	).normalized()
	
func _physics_process(delta):
	move_and_slide()

func SetDirection()->bool:
	if direction==Vector2.ZERO: return false
	
	var direction_id:int=int(round((direction).angle()/TAU*DIR_4.size()))
	var new_dir = DIR_4[direction_id]
	
	if new_dir==cardinal_direction: return false
	else:
		cardinal_direction=new_dir
		last_direction = cardinal_direction
		sprite.scale.x=-1 if cardinal_direction==Vector2.LEFT else 1
		return true
	
func UpdateAnimation(state:String)->void:
	sprite.play(state)
	pass


func _on_range_mouse_entered():
	auto_aiming=false


func _on_range_mouse_exited():
	auto_aiming=true
