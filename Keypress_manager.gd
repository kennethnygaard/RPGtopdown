extends Node


onready var players = get_tree().get_nodes_in_group("player")
onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	pass # Replace with function body.

func check_for_input():
	if(Input.is_action_just_pressed("1")):
		main.active_player = 0
	if(Input.is_action_just_pressed("2")):
		main.active_player = 1
	if(Input.is_action_just_pressed("3")):
		main.active_player = 2
	if(Input.is_action_just_pressed("4")):
		main.active_player = 3
		
	if(Input.is_action_just_pressed("ui_cancel")):
		for player in get_tree().get_nodes_in_group("player"):
			player.is_paused = !player.is_paused
			player.set_timer_paused()
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.is_paused = !enemy.is_paused
		for arrow in get_tree().get_nodes_in_group("arrow"):
			arrow.is_paused = !arrow.is_paused
		
		
func _process(delta):
	check_for_input()
	set_active_player()

func set_active_player():
	for player in players:
		player.active = false
	players[main.active_player].active = true
