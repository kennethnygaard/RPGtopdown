extends KinematicBody2D

onready var players = get_tree().get_nodes_in_group("player")
onready var damage_bubble = preload("res://Damage_bubble.tscn")
onready var main = get_tree().get_nodes_in_group("main")[0]

var HP = 20
var max_HP = 20
var speed = 50
var attacking = false
var is_ready_to_attack = false
var defence = 20
export var attack_range = 100
export var agressivity = 100

var is_paused = false

func _ready():
	for player in players:
		player.connect("melee_attack", self, "on_attacked")
	$Sprite/AnimationPlayer.play("default")
	$Red_timer.connect("timeout", self, "on_red_timer_timeout")
	$Sprite/HitBox.connect("area_entered", self, "on_arrow_hit")

func _process(delta):
	z_index = global_position.y
	if(z_index < 0):
		z_index = 0

	players = get_tree().get_nodes_in_group("player")
	var already_moved_towards_player = false
	for player in players:
		if(!player.dead && !is_paused):
			var distance = (player.global_position - global_position).length()
			if(distance < attack_range):
				if(player.global_position>global_position):
					$Sprite.flip_h = true
				if(player.global_position<global_position):
					$Sprite.flip_h = false
				if(!attacking && distance >= 25 && !is_paused && !already_moved_towards_player):
					already_moved_towards_player = true
					global_position = global_position.move_toward(player.global_position, speed*delta)
					move_and_slide(Vector2.ZERO)
			if(distance < 25):
				attack(player)

func on_arrow_hit(area2d):
	on_attacked(global_position, 1, 100)

func on_attacked(player_position, damage, hitchance):
	attack_range = agressivity
	var diff_vector = global_position - player_position
	if(diff_vector.length()<35):
		if(HP > 1):
			if(hitchance > defence):
				var newBubble = damage_bubble.instance()
				newBubble.set_text(damage)
				newBubble.z_index = 10000000
				newBubble.scale = Vector2(0.5, 0.5)		
				add_child(newBubble)
				HP -= damage
			else:
				print("defended")
		else:
			queue_free()
		var health_level = ((1.0/max_HP) * HP)
		$Healthbar/Health.scale = Vector2(health_level, 1)
		set_shader(true)
		$Red_timer.start(0.15)

func attack(player):
	if(!attacking):
		attacking = true
		$Sprite/AnimationPlayer.play("attack")
		player.lose_HP(1)
	
func stop_attack():
	attacking = false
	$Sprite/AnimationPlayer.play("default")

func set_shader(is_on):
	#$Sprite.get_material().set_shader_param("is_shader_on", is_on)
	#print("setting shader")
	pass
	
func on_red_timer_timeout():
	set_shader(false)

func set_ready_to_attack():
	is_ready_to_attack = true
