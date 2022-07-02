extends Control

onready var stats_label = get_node("stats_label")
	
func load_player_stats(stats):
	stats_label.set_text(
		"hp: " + str(stats.hp) 
	+ "\noxygen: " + str(stats.oxygen) 
	+ "\nhunger: " + str(stats.hunger))
