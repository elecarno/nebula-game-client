extends Node

onready var view_blocker
onready var area = get_node("area")
onready var sprites = get_node("sprites")
onready var interactables = get_node("interactables")
onready var effects = get_node("effects")

export var generate = false

func _ready():
	if generate == true:
		pass
