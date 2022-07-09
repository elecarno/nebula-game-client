extends Control

var playerdata
var initial_load = false
	
func load_playerdata(data):
	playerdata = data
	if initial_load == false:
		get_parent().get_parent().get_node("player").position.x = playerdata.pos.x
		get_parent().get_parent().get_node("player").position.y = playerdata.pos.y
		initial_load = true
	update_display()

func update_display():
	get_node("hunger_label").text = str(playerdata.stats.hunger) + "%"
	get_node("hunger_bar").value = playerdata.stats.hunger 
	get_node("oxygen_bar").value = playerdata.stats.oxygen
	get_node("nitrogen_bar").value = playerdata.stats.nitrogen
	get_node("hp_bar").value = playerdata.stats.hp
	get_node("helmet_visor").visible = playerdata.stats.helmet
	get_parent().get_parent().get_node("player").helmet.visible = playerdata.stats.helmet
	get_node("credits_label").text = str(playerdata.credits) + "c"

func playerhit(damage):
	playerdata.stats.hp -= damage
	if playerdata.stats.hp <= 0:
		playerdata.stats.hp = 100
	server.write_playerdata_update(playerdata)
	server.fetch_playerdata()

func togglehelmet():
	if playerdata.stats.helmet == true:
		playerdata.stats.helmet = false
	else:
		playerdata.stats.helmet = true
	server.write_playerdata_update(playerdata)
	server.fetch_playerdata()

func storeposition():
	playerdata.pos.x = get_parent().get_parent().get_node("player").position.x
	playerdata.pos.y = get_parent().get_parent().get_node("player").position.y
	server.write_playerdata_update(playerdata)
