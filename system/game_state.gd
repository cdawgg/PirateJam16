extends Node

var game_world: Node2D


func _ready():
	game_world = get_tree().root.get_node('GameWorld')
	
	# Temp, will be loaded from start menu in the future
	load_level(load("res://scenes/test_level.tscn"))


func load_level(level: PackedScene):
	var level_holder: Node2D = game_world.get_node('Level')
	
	for child in level_holder.get_children():
		level_holder.remove_child(child)
	
	var new_level = level.instantiate()
	level_holder.add_child(new_level)
