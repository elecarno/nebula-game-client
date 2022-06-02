extends Node2D

var mapstart = preload("res://world.tscn")

func _ready():
	var mapstart_instance = mapstart.instance()
	add_child(mapstart_instance)
