extends KinematicBody2D

onready var frontarm = get_node("player_body/frontarm")
onready var backarm = get_node("player_body/backarm")
onready var body = get_node("player_body/body")
onready var head = get_node("player_body/head")

func _player_identity():
	pass

func update_player(new_position, player_state):
	set_position(new_position)
	head.global_rotation = player_state["rot"]
	if player_state["flip"] == true:
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
	else:
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
