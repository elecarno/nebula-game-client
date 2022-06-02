extends Node2D

var door_obj
var door_col

func _ready():
	door_obj = get_node("door_obj")
	door_col = get_node("door_obj/StaticBody2D/door_col")
	
func _toggle_door():
	if door_obj.visible:
		door_obj.visible = false
	else:
		door_obj.visible = true
		
	if door_col.is_disabled():
		door_col.set_deferred("disabled", false)
	else:
		door_col.set_deferred("disabled", true)

func _on_door_trigger_1_body_entered(body):
	if "player" in body.name:
		_toggle_door()


func _on_door_trigger_1_body_exited(body):
	if "player" in body.name:
		_toggle_door()
