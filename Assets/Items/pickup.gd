class_name Pickup extends Node2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@export var item:Item

func create_pickup(_item:Item):
	item=_item
	sprite.texture = load(item.data.texture)
	collider.shape.radius=sprite.get_rect().size.x/2
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var added:bool
		added = InvHelper.add_inv_item(MainMenu.hotbar_inv,item)
		if added==false:
			added = InvHelper.add_inv_item(MainMenu.inv,item)
		if added:
			queue_free()
