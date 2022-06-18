extends Node2D

var player_spawn = preload("res://player/player_template.tscn")
var last_world_state = 0 # is a timestamp, not an actual state

func spawn_new_player(player_id, spawn_pos):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		if not get_node("other_players").has_node(str(player_id)):
			var new_player = player_spawn.instance()
			new_player.position = spawn_pos
			new_player.name = str(player_id)
			get_node("other_players").add_child(new_player)
		
func despawn_player(player_id):
	get_node("other_players/" + str(player_id)).queue_free()
	
func update_world_state(world_state):
	# buffer
	# interpolation
	# extrapolation
	# rubber banding
	if world_state["t"] > last_world_state:
		last_world_state = world_state["t"]
		world_state.erase("t") # needed for interpolation & extrapolation
		world_state.erase(get_tree().get_network_unique_id()) # removes this player's entry
		for player in world_state.keys():
			if get_node("other_players").has_node(str(player)):
				get_node("other_players/" + str(player)).update_player(world_state[player])
			else:
				print("spawning new player")
				spawn_new_player(player, world_state[player]["p"])
		
