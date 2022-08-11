extends StaticBody2D

export var airlock = false
export var outer_door = false
var other_door

onready var door_obj = get_parent().get_node("door_obj")
onready var door_col = get_parent().get_node("door_obj/staticbody2d/door_col")
onready var hover_sprite = get_parent().get_node("door_button/hover_sprite")
	
func _ready():
	if airlock:
		print("yes")
		if get_parent().name == "door1":
			other_door = get_parent().get_parent().get_node("door2")
		if get_parent().name == "door2":
			other_door = get_parent().get_parent().get_node("door1")
	
func _on_interact():
	if outer_door:
		if get_tree().get_root().get_node("scene_handler").get_node("map").get_node("player").get_node("player_body").get_node("head").get_node("helmet").visible == false:
			get_tree().get_root().get_node("scene_handler").get_node("map").get_node("gui/player_stats").togglehelmet()
	if airlock:
		if other_door.get_node("door_obj").visible == false:
			other_door.get_node("door_button").toggle_door()
			var t = Timer.new()
			t.set_wait_time(1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			toggle_door()
			t.queue_free()
		else:
			toggle_door()
	else:
		toggle_door()
		
func toggle_door():
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
