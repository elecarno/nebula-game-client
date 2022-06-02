extends KinematicBody2D

export var enabled = false
var cam

export var max_forward = 200
export var max_reverse = 50
export var max_side = 100
export var stop_distance = 4

func _ready():
	cam = get_node("Camera2D")

func _physics_process(delta):
	if Input.is_action_just_released("action"):
		if enabled:
			enabled = false
			cam.current = false
		else:
			enabled = true
			cam.current = true
	
	if enabled:
		look_at(get_global_mouse_position())
		if Input.is_action_pressed("move_up"):
			_move_ship("forwards")
		elif Input.is_action_pressed("move_down"):
			_move_ship("backwards")
		if Input.is_action_pressed("move_left"):
			_move_ship("left")
		if Input.is_action_pressed("move_right"):
			_move_ship("right")

func _move_ship(dir):
	if position.distance_to(get_global_mouse_position()) > stop_distance:
		var direction = get_global_mouse_position() - position
		var perpdir = direction - position
		var normalised_direction = direction.normalized()
		var direction_distance = direction.length()
		
		if dir == "forwards":
			move_and_slide(normalised_direction * max(max_forward, direction_distance))
			
		if dir == "backwards":
			move_and_slide(-normalised_direction * max(max_reverse, direction_distance))
			
		if dir == "left":
			move_and_slide(Vector2(normalised_direction.y, -normalised_direction.x) * max(max_side, direction_distance))
			
		if dir == "right":
			move_and_slide(Vector2(-normalised_direction.y, normalised_direction.x) * max(max_side, direction_distance))
