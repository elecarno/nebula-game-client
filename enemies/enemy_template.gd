extends KinematicBody2D

var max_hp = 100
var hp = 100
var type = "null"
var state = "idle"

func _ready():
	print("spawned")
	if state == "idle":
		pass
	elif state == "dead":
		print("already dead")

func update_enemy(new_position, enemy_state):
	set_position(new_position)
	max_hp = enemy_state["enemy_max_hp"]
	type = enemy_state["enemy_type"]
	state = enemy_state["enemy_state"]
	if hp != enemy_state["enemy_hp"]:
		hp = enemy_state["enemy_hp"]
	if hp <= 0:
		on_death()
		
func on_death():
	get_node("body").visible = false
	get_node("col").set_deferred("disabled", true)
	pass 
	#print("killed")

func on_hit(damage):
	server.npc_hit(int(get_name()), damage)
	print("hit " + str(hp))
