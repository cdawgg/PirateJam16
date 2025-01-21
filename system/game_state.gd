extends Node

var game_world: Node2D
var boulder: Boulder
var camera: Camera

var level: Level
var level_packed: PackedScene

## Kill counts
var level_kill_count: int = 0: # Enemies killed in the current run of the level
	set(val):
		level_kill_count = val
		UILayer.set_score(level_kill_count, level.enemies.size())
var total_kill_count: int = 0 # Enemies killed in previous levels
var max_kill_count: int = 0 # Potential of enemies killed in previous levels

## Upgrades
var gun_unlocked: bool = true

signal level_started


func _ready():
	game_world = get_tree().root.get_node('GameWorld')
	boulder = game_world.get_node('Boulder')
	camera = game_world.get_node('Camera2D')


func load_level(_level_packed: PackedScene):
	var level_holder: Node2D = game_world.get_node('Level')
	
	for child in level_holder.get_children():
		level_holder.remove_child(child)
	
	level_packed = _level_packed
	level = level_packed.instantiate()
	level_holder.add_child(level)
	start_level()


func restart_level():
	UILayer.show_death_screen(false)
	boulder.revive()
	load_level(level_packed)
	start_level()


func start_level():
	level_kill_count = 0
	
	boulder.process_mode = Node.PROCESS_MODE_DISABLED
	boulder.stop_movement()
	camera.set_follow_target(boulder)
	
	boulder.enable_gun(gun_unlocked)
	
	boulder.process_mode = Node.PROCESS_MODE_INHERIT
	boulder.position = level.spawn_point.position
	boulder.disable_input(false)
	
	level_started.emit()


func finish_level():
	total_kill_count += level_kill_count
	max_kill_count += level.enemies.size()


func shake_camera(strength: float):
	camera.shake(strength)
