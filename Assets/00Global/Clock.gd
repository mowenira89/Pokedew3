class_name Clock extends Node

@onready var timer: Timer = $Timer

var hour:int = 6
var minute:int = 0
var am = true
func _ready():
	timer.start(10)

func _on_timer_timeout() -> void:
	minute+=1
	if minute==7:
		minute=0
		hour+=1
		if hour==13:
			hour=1
			am = !am
	Signals.ten_seconds_passed.emit()
