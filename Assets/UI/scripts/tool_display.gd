extends Control

var chosen_tool:Item



var outer_radius=50
var background_color=Color("#7402ff")
func _draw():
	draw_circle(Vector2.ZERO,outer_radius,background_color)
