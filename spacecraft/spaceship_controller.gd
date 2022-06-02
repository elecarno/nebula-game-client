extends KinematicBody2D

export var enabled = false
var cam

var max_forward
var max_reverse
var max_side
var stop_distance

func _ready():
	# wait one second to allow client to connect
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	# call data fetch from server singleton
	server.fetch_shipdata("testship", get_instance_id())
	# free timer to avoid memory leak
	t.queue_free()
	
	cam = get_node("Camera2D")
	
func setdata(s_shipdata):
	print("data fetch successful, data set")
	max_forward = s_shipdata.max_forward
	max_reverse = s_shipdata.max_reverse
	max_side = s_shipdata.max_side
	stop_distance = s_shipdata.stop_distance

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
