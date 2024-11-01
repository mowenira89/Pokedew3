extends Panel
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func write_message(s:String):
	label.text = s
	timer.start(10)
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 2)
	tween.play()
	await tween.finished
	tween.kill()
	queue_free()


func _on_timer_timeout() -> void:
	fade_out()
