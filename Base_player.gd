extends KinematicBody2D

onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var main = get_tree().get_nodes_in_group("main")[0]
onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var damage_bubble = preload("res://Damage_bubble.tscn")
onready var arrow = preload("res://Arrow.tscn")
onready var rng = RandomNumberGenerator.new()

#stats
var strength = 1
export var max_HP = 5
onready var current_HP = max_HP
var move_speed = 200
var attack_speed = 1
var dead = false

var attacking = false
var is_paused = false

var attack_mode = false

signal melee_attack(position, damage, hit_percent)

var active = true
onready var move_to_goal = global_position

export var bowman = true
export var sprite_path = "res://assets/robin_hood.png"

var move_vector = Vector2.ZERO
var arrow_destination = Vector2.ZERO
var attack_pos = Vector2.ZERO

func _ready():
	rng = randomize()
	$Move_to_goal.visible = false
	$Get_ready_to_attack_timer.connect("timeout", self, "set_ready_to_attack")
	var texture = load(sprite_path)
	$Sprite.texture = texture
	print(max_HP, ", ", current_HP)
	$Potion_area2d.connect("area_entered", self, "on_potion_drank")

func _process(delta):
	if(dead):
		$Sprite.frame = 6
		$Healthbar.visible = false
	else:
		z_index = global_position.y
		if(z_index < 0):
			z_index = 0
		set_move_to_goal_visibility()

		if(!is_paused):
			global_position = global_position.move_toward(move_to_goal, move_speed*delta)
			move_and_slide(Vector2.ZERO)
		$Move_to_goal.global_position = move_to_goal

		if(move_to_goal.x > global_position.x):
			$Sprite.flip_h = true
		if(move_to_goal.x < global_position.x):
			$Sprite.flip_h = false

		if(!bowman):
			melee_attack()

		play_animations()

func _input(event):
	if(active && !dead):
		if(event is InputEventMouseButton and event.is_action_released("left_mouse_button_click") and event.button_index == BUTTON_LEFT):
			var diff_x = event.position.x - 512
			var diff_y = event.position.y - 300
			var x = camera.global_position.x + diff_x * camera.zoom.x
			var y = camera.global_position.y + diff_y * camera.zoom.y - 12
			move_to_goal = Vector2(x, y)
			attack_mode = false

		if(event is InputEventMouseButton and event.is_action_released("right_mouse_button_click") and event.button_index == BUTTON_RIGHT):
			if(bowman):
				var clickpos = Vector2.ZERO
				clickpos.x = camera.global_position.x - 512*camera.zoom.x + event.position.x * camera.zoom.x
				clickpos.y = camera.global_position.y - 300*camera.zoom.y + event.position.y * camera.zoom.y
				ranged_attack(clickpos)
				attack_mode = true

func melee_attack():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var dist = (global_position - enemy.global_position).length()
		if(dist < 30 && !attacking):
			emit_signal("melee_attack", global_position, 1, 100)
			$Sprite/AnimationPlayer.play("melee_attack")
			$Get_ready_to_attack_timer.start(attack_speed)
			attacking = true

func ranged_attack(pos):
	move_to_goal = global_position
	arrow_destination = pos
	if(!attacking ):
		if(arrow_destination.x > global_position.x):
			$Sprite.flip_h = true
		if(arrow_destination.x < global_position.x):
			$Sprite.flip_h = false
		$Sprite/AnimationPlayer.play("fire_arrow")
		$Get_ready_to_attack_timer.start(1)
		attacking = true
	
func fire_arrow():
	var newArrow = arrow.instance()
	newArrow.global_position = global_position
	newArrow.set_direction(arrow_destination)
	newArrow.is_paused = is_paused
	main.add_child(newArrow)


func play_animations():
	var dist = (global_position - move_to_goal).length()
	if(attacking):
		pass
	elif(dist > 5):
		$Sprite/AnimationPlayer.play("walking")
	else:
		$Sprite/AnimationPlayer.play("idle")

func lose_HP(hits_lost):
	if(current_HP>0):
		var newBubble = damage_bubble.instance()
		#newBubble.global_position = global_position - Vector2(0, 20)
		newBubble.set_text(hits_lost)
		newBubble.z_index = 10000000
		newBubble.scale = Vector2(0.5, 0.5)
		newBubble.position.y -= 15
		add_child(newBubble)
		current_HP -= hits_lost
		current_HP = clamp(current_HP, 0, max_HP)
	else:
		dead = true
	update_health_bar()

func set_move_to_goal_visibility():
	var dist_to_move_goal = (move_to_goal - global_position).length()
	if(dist_to_move_goal > 5):
		$Move_to_goal.visible = true
	else:
		$Move_to_goal.visible = false	

func update_health_bar():
	var healthbar_scale = 1.0*current_HP/max_HP
	$Healthbar/Health.scale = Vector2(healthbar_scale, 1)

func set_ready_to_attack():
	attacking = false

	if(bowman && attack_mode && !dead):
		ranged_attack(arrow_destination)
	
func set_timer_paused():
	$Get_ready_to_attack_timer.paused = !$Get_ready_to_attack_timer.paused

func on_potion_drank(area2d):
	current_HP = max_HP
	update_health_bar()
