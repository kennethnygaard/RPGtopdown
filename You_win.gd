extends Node2D

onready var camera = get_tree().get_nodes_in_group("camera")[0]

func _ready():
	global_position = camera.global_position
	$Particles2D.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
