extends Sprite

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var rotate = false
	if Input.is_action_pressed("lmb"):
		rotate = true
	else:
		rotate = false
	
	var look_vec = get_global_mouse_position() - global_position
	
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		set_flip_h(true)
		offset = Vector2(0, 1.5)
		position = Vector2(1.5, -1.5)
		if rotate:
			global_rotation = atan2(-look_vec.y, -look_vec.x) + PI/2
		else:
			global_rotation = 0
	else:
		set_flip_h(false)
		offset = Vector2(0, 1.5)
		position = Vector2(-1.5, -1.5)
		if rotate:
			global_rotation = atan2(look_vec.y, look_vec.x) - PI/2
		else:
			global_rotation = 0
