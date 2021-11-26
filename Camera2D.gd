extends Camera2D

onready var players = get_tree().get_nodes_in_group("player")
onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	pass # Replace with function body.


func _process(delta):
	
	global_position = global_position.move_toward(players[main.active_player].global_position, delta*225)
