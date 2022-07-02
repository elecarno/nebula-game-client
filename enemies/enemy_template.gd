extends Node2D

var max_hp = 0
var hp = 0
var type = "null"
var state = "idle"

func update_enemy(new_position, enemy_state):
	set_position(new_position)
	hp = enemy_state["enemy_hp"]

func on_hit(damage):
	server.npc_hit(int(get_name()), damage)
