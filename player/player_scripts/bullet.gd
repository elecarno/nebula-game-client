extends RigidBody2D

export var speed = 300
export var rotation_angle = 0
var local = true

func _ready():
	set_as_toplevel(true)
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation_angle))

func _on_damage_area_body_entered(body):
	if not body.name == self.name:
		if body.is_in_group("enemies") and local == true:
			body.on_hit(10)
		get_node("col").set_deferred("disabled", true)
		get_node("bolt").hide()
		get_node("hit").emitting = true
		if body.is_in_group("players"):
			get_node("blood_hit").emitting = true
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		get_node("hit").hide()
		get_node("blood_hit").hide()
		t.queue_free()
		self.sleeping = true
