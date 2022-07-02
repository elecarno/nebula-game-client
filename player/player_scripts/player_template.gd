extends KinematicBody2D

onready var frontarm = get_node("player_body/body/frontarm")
onready var body = get_node("player_body/body")
onready var head = get_node("player_body/head")
onready var item = get_node("player_body/body/frontarm/held_item")
onready var anim = get_node("player_body/anim_player")

func _player_identity():
	pass

func update_player(new_position, player_state):
	anim.play(player_state["anim"])
	set_position(new_position)
	head.global_rotation = player_state["rot"]
	frontarm.global_rotation = player_state["armrot"]
	if player_state["anim"] == "idle_up":
		frontarm.position = Vector2(1.5, -4.5)
		frontarm.show_behind_parent = true
		item.set_flip_v(true)
	if player_state["anim"] == "idle_down":
		frontarm.position = Vector2(-2.5, -4.5)
		frontarm.show_behind_parent = false
		item.set_flip_v(false)
	if player_state["anim"] == "idle_left":
		frontarm.show_behind_parent = true
		frontarm.position = Vector2(-0.5, -4.5)
		item.set_flip_v(true)
	if player_state["anim"] == "idle_right":
		frontarm.position = Vector2(-0.5, -4.5)
		frontarm.show_behind_parent = false
		item.set_flip_v(false)
