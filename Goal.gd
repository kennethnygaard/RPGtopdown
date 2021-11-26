extends KinematicBody2D

onready var main = get_tree().get_nodes_in_group("main")[0]
var you_win = preload("res://You_win.tscn")

func _ready():
	$Area2D.connect("area_entered", self, "on_goal_entered")

func on_goal_entered(area2d):
	var new_Win = you_win.instance()
	main.add_child(new_Win)	
