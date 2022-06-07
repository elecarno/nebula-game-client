extends Control

onready var username_input = get_node("username")
onready var userpassword_input = get_node("password")
onready var login_button = get_node("login_button")

func _on_login_button_pressed():
	if username_input.text == "" or userpassword_input.text == "":
		# popup and stop
		print("please provide valid user id and password")
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = userpassword_input.get_text()
		print("attempting to login")
		gateway.connect_to_server(username, password)
