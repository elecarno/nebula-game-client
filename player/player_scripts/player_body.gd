extends Sprite

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		set_flip_h(true)
	else:
		set_flip_h(false)
