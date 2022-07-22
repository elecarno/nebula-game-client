extends KinematicBody2D

onready var col = get_node("col")
var type = "idle"
var pickup_state = {}
var picked_up = false

func pickup():
	if col.disabled == true:
		col.set_deferred("disabled", false)
	else:
		col.set_deferred("disabled", true)
	picked_up = true

func _physics_process(delta):
	if picked_up == true:
		pickup_state = {
			"t": OS.get_system_time_msecs(),
			"p": get_global_position()
		}
		server.send_pickup_state(pickup_state, self.name)

func update_pickup(new_pos, pickup_state_dict):
	set_position(new_pos)
