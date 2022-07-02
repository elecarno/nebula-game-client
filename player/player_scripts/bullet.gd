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
		self.hide()
