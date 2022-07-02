extends Node2D

var door_obj
var door_col

func _ready():
	door_obj = get_node("door_obj")
	door_col = get_node("door_obj/StaticBody2D/door_col")
	
func _open_door()	:
	door_obj.visible = false
	door_col.set_deferred("disabled", true)

func _close_door()	:
	door_obj.visible = true
	door_col.set_deferred("disabled", false)

func _on_door_trigger_1_body_entered(body):
	if body.is_in_group("players"):
		_open_door()

func _on_door_trigger_1_body_exited(body):
	if body.is_in_group("players"):
		_close_door()
