extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_parent().modulate="#ffffff80"


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_parent().modulate="$ffffffff"
