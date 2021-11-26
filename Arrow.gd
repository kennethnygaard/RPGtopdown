extends KinematicBody2D

var speed = 250
var move_vector = Vector2.ZERO
var is_paused = false

func _ready():
	$Sprite/Area2D.connect("area_entered", self, "on_area_entered")

func set_direction(pos):
	move_vector = pos - global_position
	move_vector = move_vector.normalized()*speed
	$Sprite.rotate(move_vector.angle())

func _process(delta):
	if(!is_paused):
		var coll = move_and_collide(move_vector*delta)
		if(coll != null):
			if(coll.collider is TileMap):
				queue_free()
			else:
				move_and_slide(move_vector)
	
func on_area_entered(area2d):
	queue_free()
