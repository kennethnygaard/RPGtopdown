extends KinematicBody2D



func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")
	$Timer.connect("timeout", self, "on_timeout")


func on_area_entered(area2d):
	$Particles2D.emitting = true
	$Particles2D.z_index = 10000000
	$Sprite.visible = false
	$Timer.start(1)
	
func on_timeout():
	queue_free()
