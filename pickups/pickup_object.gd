extends KinematicBody2D

onready var col = get_node("col")
var type = "idle"

func pickup():
	if col.disabled == true:
		col.set_deferred("disabled", false)
	else:
		col.set_deferred("disabled", true)

func update_pickup(new_pos, pickup_state):
	set_position(new_pos)
