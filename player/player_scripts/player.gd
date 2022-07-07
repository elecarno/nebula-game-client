extends KinematicBody2D

export var enabled = true

onready var cam = get_node("cam2d")
onready var intr_cast = get_node("player_body/body/frontarm/intr_cast")
onready var frontarm = get_node("player_body/body/frontarm")
onready var rightarm = get_node("player_body/body/rightarm")
onready var body = get_node("player_body/body")
onready var head = get_node("player_body/head")
onready var item = get_node("player_body/body/frontarm/held_item")
onready var muzzle_flash = get_node("player_body/body/frontarm/muzzle_flash")
onready var anim = get_node("player_body/anim_player")
onready var armanim = get_node("player_body/rightarm_anim")
onready var proj_spawn = get_node("player_body/body/frontarm/proj_spawn")
onready var bullet = preload("res://player/bullet.tscn")

const move_speed = 100
var gravity = true

var player_state
var moving = false
var walking = false
var flip = false
var head_look_offset = 0

func _ready():
	anim.play("idle_down")
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
		if Input.is_action_just_released("move_up"):
			anim.play("idle_up")
			armanim.stop()
			rightarm.visible = false
			frontarm.visible = true
		if Input.is_action_just_released("move_down"):
			anim.play("idle_down")
			armanim.stop()
			rightarm.visible = false
			frontarm.visible = true
		if Input.is_action_just_released("move_left"):
			anim.play("idle_left")
			armanim.stop()
			rightarm.visible = false
			frontarm.visible = true
		if Input.is_action_just_released("move_right"):
			anim.play("idle_right")
			armanim.stop()
			rightarm.visible = false
			frontarm.visible = true
		if Input.is_action_pressed("move_up"):
			move_vec.y -=1
			configure_character("walk_up", "arm_walk_up", Vector2(1.5, -4.5), true, PI/2 * -1, true, true)
		if Input.is_action_pressed("move_down"):
			move_vec.y +=1
			configure_character("walk_down", "arm_walk_down", Vector2(-2.5, -4.5), false, PI/2, false, true)
		if Input.is_action_pressed("move_left"):
			move_vec.x -=1
			configure_character("walk_left", "arm_walk_left", Vector2(-2.5, -4.5), true, 0, true, true)
		if Input.is_action_pressed("move_right"):
			move_vec.x +=1
			configure_character("walk_right", "arm_walk_right", Vector2(-2.5, -4.5), false, 0, false, true)
	
		# probably a better way to do this
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			if Input.is_action_pressed("rmb"):
				rightarm.visible = false
				frontarm.visible = true
			else:
				rightarm.visible = true
				frontarm.visible = false
			walking = true
		else:
			walking = false
			
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * move_speed * delta)
	
	# rotation and flipping
	var rotate = false
	if Input.is_action_pressed("rmb"):
		rotate = true
	else:
		rotate = false
	
	if Input.is_action_just_released("lmb"):
		if intr_cast.is_colliding():
			var collider = intr_cast.get_collider()
			collider._on_interact()
		else:
			if rotate == true:
				server.send_attack(position, frontarm.rotation_degrees + 90, frontarm.rotation + PI/2)
				muzzle_flash.emitting = true
				var bullet_instance = bullet.instance()
				bullet_instance.position = proj_spawn.global_position
				bullet_instance.rotation_degrees = frontarm.rotation_degrees + 90
				bullet_instance.rotation_angle = frontarm.rotation + PI/2
				get_parent().add_child(bullet_instance)
	
	var look_vec = get_global_mouse_position() - frontarm.global_position
	var direction = sign(get_global_mouse_position().x - frontarm.global_position.x)
	if direction < 0:
		flip = true
		head.global_rotation = atan2(-look_vec.y, -look_vec.x) + head_look_offset
		if rotate:
			frontarm.global_rotation = atan2(-look_vec.y, -look_vec.x) + PI/2
		else:
			frontarm.global_rotation = 0
	else:
		flip = false
		head.global_rotation = atan2(look_vec.y, look_vec.x) - head_look_offset
		if rotate:
			frontarm.global_rotation = atan2(look_vec.y, look_vec.x) - PI/2
		else:
			frontarm.global_rotation = 0
			
	# player syncronisation
	define_player_state()
	
func configure_character(anima, armanima, armpos, armshow, lookoff, itemflip, rightvis):
	anim.play(anima)
	armanim.play(armanima)
	frontarm.position = armpos
	frontarm.show_behind_parent = armshow
	head_look_offset = lookoff
	item.set_flip_v(itemflip)
	rightarm.visible = rightvis

func _on_area2d_body_entered(body):
	if "gravity_area" in body.name:
		print("player in gravity")
		
func define_player_state():
	# if we have differnt maps, a map_node must be included
	player_state = {
		"t": OS.get_system_time_msecs(), 
		"p": get_global_position(),
		"rot": head.global_rotation,
		"armrot": frontarm.global_rotation,
		"anim": anim.current_animation
	}
	server.send_player_state(player_state)
