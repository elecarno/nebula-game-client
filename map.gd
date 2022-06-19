extends Node2D

var player_spawn = preload("res://player/player_template.tscn")
var last_world_state = 0 # is a timestamp, not an actual state

# [previous past, most recent past, nearest future, further future]
var world_state_buffer = []
const interpolation_offset = 100

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
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("other_players/" + str(player_id)).queue_free()
	
func update_world_state(world_state):
	if world_state["t"] > last_world_state:
		last_world_state = world_state["t"]
		world_state_buffer.append(world_state)
		
func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].t:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2: # we have a future state (interpolation can be used)
			var interpolation_factor = float(render_time - world_state_buffer[1]["t"]) / float(world_state_buffer[2]["t"] - world_state_buffer[1]["t"])
			for player in world_state_buffer[2].keys():
				if str(player) == "t":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if get_node("other_players").has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["p"], world_state_buffer[2][player]["p"], interpolation_factor)
					get_node("other_players/" + str(player)).update_player(new_position, world_state_buffer[2][player])
				else:
					print("spawning player")
					spawn_new_player(player, world_state_buffer[2][player]["p"])
		elif render_time > world_state_buffer[1].t: # there is no future state and extrapolation must be used
			var extrapolation_factor = float(render_time - world_state_buffer[0]["t"]) / float(world_state_buffer[1]["t"]) - 1.00 # minus one to exclude time between world states
			for player in world_state_buffer[1].keys():
				if str(player) == "t":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if get_node("other_players").has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["p"] - world_state_buffer[0][player]["p"])
					var new_position = world_state_buffer[1][player]["p"] + (position_delta * extrapolation_factor)
					get_node("other_players/" + str(player)).update_player(new_position, world_state_buffer[1][player])
