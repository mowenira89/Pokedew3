@tool
extends Control

@export var background_color:Color
@export var line_color:Color

@export var outer_radius:int = 256
@export var inner_radius:int = 64
@export var line_width:int = 4

@export var options:Array[WheelOption]

const SPRITE_SIZE = Vector2(96,96) 

func _draw():
	var offset = SPRITE_SIZE/-2
	
	draw_circle(Vector2.ZERO,outer_radius,background_color)
	draw_arc(Vector2.ZERO,inner_radius,0,TAU,128,line_color,line_width)

	if len(options)>3:
		for i in range(len(options)-1):
			var rads = TAU * i/(len(options)-1)
			var point = Vector2.from_angle(rads)
			draw_line(point*inner_radius,point*outer_radius,line_color,line_width,true)
	draw_texture_rect_region(options[0].atlas,
							Rect2(offset,SPRITE_SIZE),
							options[0].region)
								
	for i in range(1,len(options)):
		var start_rads = (TAU*(i-1))/(len(options)-1)
		var end_rads = (TAU*i)/(len(options)-1)
		var mid_rads = (start_rads+end_rads)/2.0*-1
		var radius_mid = (inner_radius+outer_radius)/2
		
		var draw_position = radius_mid * Vector2.from_angle(mid_rads)+offset
		
		draw_texture_rect_region(
			options[i].atlas,
			Rect2(draw_position,SPRITE_SIZE),
			options[i].region
		)

func _process(delta):
	
	queue_redraw()
