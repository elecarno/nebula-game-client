extends StaticBody2D

var door_obj
var door_col
var hover_sprite

func _ready():
	door_obj = get_parent().get_node("door_obj")
	door_col = get_parent().get_node("door_obj/staticbody2d/door_col")
	hover_sprite = get_parent().get_node("door_button/hover_sprite")
	
func _on_interact():
	if door_obj.visible:
		door_obj.visible = false
	else:
		door_obj.visible = true
		
	if door_col.is_disabled():
		door_col.set_deferred("disabled", false)
	else:
		door_col.set_deferred("disabled", true)


func _on_Area2D_mouse_entered():
	hover_sprite.visible = true


func _on_Area2D_mouse_exited():
	hover_sprite.visible = false
