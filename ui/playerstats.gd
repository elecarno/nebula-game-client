extends Control

onready var stats_label = get_node("stats_label")

func _ready():
	# wait one second to allow client to connect
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	# call data fetch from server singleton
	if not server.use_auth:
		server.fetch_playerstats()
	# free timer to avoid memory leak
	t.queue_free()

	
func load_player_stats(stats):
	stats_label.set_text(
		"hp: " + str(stats.hp) 
	+ "\noxygen: " + str(stats.oxygen) 
	+ "\nhunger: " + str(stats.hunger))
