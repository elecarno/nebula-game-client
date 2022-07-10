extends KinematicBody2D

var rng = RandomNumberGenerator.new()

onready var frontarm = get_node("player_body/body/frontarm")
onready var rightarm = get_node("player_body/body/rightarm")
onready var armanim = get_node("player_body/rightarm_anim")

onready var body = get_node("player_body/body")
onready var anim = get_node("player_body/anim_player")
onready var hitsfx = get_node("hitsfx")

onready var head = get_node("player_body/head")
onready var helmet = get_node("player_body/head/helmet")

onready var item = get_node("player_body/body/frontarm/held_item")
onready var muzzle_flash = get_node("player_body/body/frontarm/muzzle_flash")
onready var shootsfx = get_node("player_body/body/frontarm/pistol_shot")
onready var proj_spawn = get_node("player_body/body/frontarm/proj_spawn")
onready var bullet = preload("res://player/bullet.tscn")

var attack_dict = {}
var state = "idle"

func _physics_process(delta):
	if not attack_dict == {}:
		attack()

func update_player(new_position, player_state):
	anim.play(player_state["anim"])
	set_position(new_position)
	head.global_rotation = player_state["rot"]
	frontarm.global_rotation = player_state["armrot"]
	rightarm.visible = player_state["armvis"]
	helmet.visible = player_state["helmet"]
	
	if player_state["anim"] == "idle_up" or player_state["anim"] == "walk_up":
		configure_character(Vector2(1.5, -4.5), true, true)
	if player_state["anim"] == "idle_down" or player_state["anim"] == "walk_down":
		configure_character(Vector2(-2.5, -4.5), false, false)
	if player_state["anim"] == "idle_left" or player_state["anim"] == "walk_left":
		configure_character(Vector2(-2.5, -4.5), true, true)
	if player_state["anim"] == "idle_right" or player_state["anim"] == "walk_right":
		configure_character(Vector2(-2.5, -4.5), false, false)
		
func configure_character(armpos, armshow, itemflip):
	frontarm.position = armpos
	frontarm.show_behind_parent = armshow
	item.set_flip_v(itemflip)

func attack():
	for attack in attack_dict.keys():
		if attack <= server.client_clock:
			var bullet_instance = bullet.instance()
			rng.randomize()
			shootsfx.pitch_scale = rng.randf_range(0.8, 1)
			muzzle_flash.emitting = true
			shootsfx.play()
			muzzle_flash.emitting = true
			bullet_instance.local = false
			bullet_instance.position = proj_spawn.global_position
			bullet_instance.rotation_degrees = attack_dict[attack]["rotdeg"]
			bullet_instance.rotation_angle = attack_dict[attack]["rot"]
			attack_dict.erase(attack)
			yield(get_tree().create_timer(0.2), "timeout")
			get_parent().add_child(bullet_instance)
			yield(get_tree().create_timer(0.2), "timeout")
			
func _on_area2d_body_entered(body):
	if body.is_in_group("bullet"):
		rng.randomize()
		hitsfx.pitch_scale = rng.randf_range(0.7, 1.1)
		hitsfx.play()
