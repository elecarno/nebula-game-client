extends Node

# development ip & port
const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 1909

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var token

var local_player_id = 0
sync var players = {}
sync var player_data = {}

export var use_auth = true

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	if not use_auth:
		connect_to_server()

func connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("player " + str(id) + " connected")
	
func _player_disconnected(id):
	print("player " + str(id) + " disconnected")
	
func _connected_ok():
	print("successfully connected to server")
	
func _connected_fail():
	print("failed to connect to server")
	
func _server_disconnected():
	print("server disconnected")
	
remote func fetch_token():
	rpc_id(1, "return_token", token)
	
remote func return_token_verification_results(result):
	var alert_label = get_node("../scene_handler/map/gui/login_system/alert_label")
	if result == true:
		print("successful token verifcation")
		alert_label.text = "successful token verifcation"
		get_node("../scene_handler/map/gui/login_system").queue_free()
		get_node("../scene_handler/map/player").set_physics_process(true)
	else:
		print("login failed, please try again")
		alert_label.text = "login failed, please try again"
		get_node("../scene_handler/map/gui/login_system").login_button.disabled = false
		get_node("../scene_handler/map/gui/login_system").create_acc_button.disabled = false
		
func send_player_state(player_state):
	rpc_unreliable_id(1, "recieve_player_state", player_state)

remote func recieve_world_state(world_state):
	get_node("../scene_handler/map").update_world_state(world_state)
		
remote func spawn_new_player(player_id, spawn_pos):
	get_node("../scene_handler/map").spawn_new_player(player_id, spawn_pos)
	
remote func despawn_player(player_id):
	get_node("../scene_handler/map").despawn_player(player_id)
	
# `rpc_id()` calls `remote func fetch_shipdata()` on id 1 (the server)
func fetch_shipdata(ship_name, requester):
	rpc_id(1, "fetch_shipdata", ship_name, requester)
	print("fetching data for: " + ship_name)

# this function is a called from the server, hence the `remote` tag
# `s_` identifies variables from server, `instance_from_id` references
# the id of the initial caller from `fetch_shipdata`
remote func return_shipdata(s_shipdata, requester):
	print("recieved data: " + str(s_shipdata))
	instance_from_id(requester).setdata(s_shipdata)
	
func fetch_playerstats():
	rpc_id(1, "fetch_playerstats")

remote func return_player_stats(stats):
	print("recieved " + str(stats))
	get_node("/root/scene_handler/map/gui/player_stats").load_player_stats(stats)
