extends KinematicBody2D

export var enabled = true
var cam

const move_speed = 100
var gravity = true
var intr_cast
var hover_cast

func _ready():
	intr_cast = get_node("player_body/frontarm/intr_cast")
	hover_cast = get_node("player_body/head/hover_cast")
	cam = get_node("Camera2D")

func _physics_process(delta):
	var move_vec = Vector2()
	
	if Input.is_action_just_released("action"):
		if enabled:
			enabled = false
			cam.current = false
		else:
			enabled = true
			cam.current = true
	
	if gravity && enabled:
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
	
	if Input.is_action_just_released("lmb") and intr_cast.is_colliding():
		var collider = intr_cast.get_collider()
		collider._on_interact()

func _on_Area2D_body_entered(body):
	if "gravity_area" in body.name:
		print("player in gravity")
