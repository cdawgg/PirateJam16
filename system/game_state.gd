extends Node

var game_world: Node2D
var boulder: Boulder
var camera: Camera2D
var level: Level

var kill_count: int = 0
var max_kill_count: int = 0


func _ready():
	game_world = get_tree().root.get_node('GameWorld')
	boulder = game_world.get_node('Boulder')
	camera = boulder.get_node('Camera2D')
	
	# Temp, will be loaded from start menu in the future
	load_level(load("res://scenes/test_level.tscn"))


func load_level(level_packed: PackedScene):
	var level_holder: Node2D = game_world.get_node('Level')
	
	for child in level_holder.get_children():
		level_holder.remove_child(child)
	
	level = level_packed.instantiate()
	level_holder.add_child(level)
	camera.reparent(boulder)


func restart_level():
	level.reset()
	boulder.process_mode = Node.PROCESS_MODE_DISABLED
	boulder.stop_movement()
	camera.reparent(boulder)
	camera.position = Vector2.ZERO
	boulder.process_mode = Node.PROCESS_MODE_INHERIT
	boulder.position = level.spawn_point.position


func finish_level():
	kill_count += level.get_kill_count()
	max_kill_count += level.enemies.size()


func freeze_camera():
	var old_pos: Vector2 = camera.global_position
	camera.reparent(game_world)
	camera.global_position = old_pos
