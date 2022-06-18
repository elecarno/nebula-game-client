extends KinematicBody2D

export var enabled = true

onready var cam = get_node("cam2d")
onready var intr_cast = get_node("player_body/frontarm/intr_cast")
onready var frontarm = get_node("player_body/frontarm")
onready var backarm = get_node("player_body/backarm")
onready var body = get_node("player_body/body")
onready var head = get_node("player_body/head")

const move_speed = 100
var gravity = true

var player_state
var moving = false
var flip = false

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	# control switching
	if Input.is_action_just_released("action"):
		if enabled:
			enabled = false
			cam.current = false
		else:
			enabled = true
			cam.current = true
		
	# movement
	var move_vec = Vector2()
	
	if gravity and enabled:
		if Input.is_action_pressed("move_up"):
			move_vec.y -=1
		if Input.is_action_pressed("move_down"):
			move_vec.y +=1
		if Input.is_action_pressed("move_left"):
			move_vec.x -=1
		if Input.is_action_pressed("move_right"):
			move_vec.x +=1
			
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * move_speed * delta)
	
	# rotation and flipping
	var rotate = false
	if Input.is_action_just_released("lmb") and intr_cast.is_colliding():
		var collider = intr_cast.get_collider()
		collider._on_interact()
	if Input.is_action_pressed("lmb"):
		rotate = true
	else:
		rotate = false
	
	var look_vec = get_global_mouse_position() - frontarm.global_position
	var direction = sign(get_global_mouse_position().x - frontarm.global_position.x)
	if direction < 0:
		flip = true
		body.set_flip_h(true)
		frontarm.set_flip_h(true)
		frontarm.offset = Vector2(0, 1.5)
		frontarm.position = Vector2(1.5, -1.5)
		backarm.set_flip_h(true)
		backarm.offset = Vector2(0, 1.5)
		backarm.position = Vector2(1.5, -1.5)
		head.set_flip_h(true)
		head.offset = Vector2(-1, -1)
		head.position = Vector2(0.5, -3.5)
		head.global_rotation = atan2(-look_vec.y, -look_vec.x)
		if rotate:
			frontarm.global_rotation = atan2(-look_vec.y, -look_vec.x) + PI/2
		else:
			frontarm.global_rotation = 0
	else:
		flip = false
		body.set_flip_h(false)
		frontarm.set_flip_h(false)
		frontarm.offset = Vector2(0, 1.5)
		frontarm.position = Vector2(-1.5, -1.5)
		backarm.set_flip_h(false)
		backarm.offset = Vector2(0, 1.5)
		backarm.position = Vector2(-1.5, -1.5)
		head.set_flip_h(false)
		head.offset = Vector2(1, -1)
		head.position = Vector2(-0.5, -3.5)
		head.global_rotation = atan2(look_vec.y, look_vec.x)
		if rotate:
			frontarm.global_rotation = atan2(look_vec.y, look_vec.x) - PI/2
		else:
			frontarm.global_rotation = 0
			
	# player syncronisation
	define_player_state()

func _on_area2d_body_entered(body):
	if "gravity_area" in body.name:
		print("player in gravity")
		
func define_player_state():
	# if we have differnt maps, a map_node must be included
	player_state = {
		"t": OS.get_system_time_msecs(), 
		"p": get_global_position(),
		"rot": head.global_rotation,
		"flip": flip
	}
	server.send_player_state(player_state)
