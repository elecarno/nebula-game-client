extends Sprite

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var look_vec = get_global_mouse_position() - global_position
	
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		set_flip_h(true)
		offset = Vector2(-1, -1)
		position = Vector2(0.5, -3.5)
		global_rotation = atan2(-look_vec.y, -look_vec.x)
	else:
		set_flip_h(false)
		offset = Vector2(1, -1)
		position = Vector2(-0.5, -3.5)
		global_rotation = atan2(look_vec.y, look_vec.x)
