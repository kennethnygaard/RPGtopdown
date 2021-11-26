extends KinematicBody2D

onready var damage_bubble = preload("res://Damage_bubble.tscn")

var move_vector = Vector2.ZERO
var move_speed = 200
var active = false
var attacking = false
var max_hits = 12
var hits = max_hits

var is_paused = false

func _ready():
	pass

func _process(delta):
	z_index = global_position.y
	
	if(active):
		check_for_keyboard_input()
	move_vector = move_vector.normalized()
	move_vector *= move_speed
	
	if(move_vector.x > 0):
		$Sprite.flip_h = true
	if(move_vector.x < 0):
		$Sprite.flip_h = false
	
	move_and_slide(move_vector)

func check_for_keyboard_input():
	move_vector = Vector2.ZERO
	if(Input.is_action_pressed("ui_left")):
		move_vector.x -= 1
	if(Input.is_action_pressed("ui_right")):
		move_vector.x += 1
	if(Input.is_action_pressed("ui_up")):
		move_vector.y -= 1
	if(Input.is_action_pressed("ui_down")):
		move_vector.y += 1

func lose_HP(hits_lost):
	print("attacked")
	if(hits>1):
		var newBubble = damage_bubble.instance()
		#newBubble.global_position = global_position - Vector2(0, 20)
		newBubble.set_text(1)
		newBubble.z_index = 10000000
		newBubble.scale = Vector2(0.5, 0.5)
		newBubble.position.y -= 15
		add_child(newBubble)
		hits -= 1
	update_healthbar()

func update_healthbar():
	var healthbar_scale = 1.0*hits/max_hits
	$Healthbar/Health.scale = Vector2(healthbar_scale, 1)

func set_timer_paused():
	pass
