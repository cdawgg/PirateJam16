extends Node

var game_world: Node2D
var boulder: Boulder
var camera: Camera

@onready var levels: Array[PackedScene] = [
	preload('res://scenes/test_level.tscn'),
	preload('res://scenes/level1.tscn'),
	preload('res://scenes/level2.tscn'),
	preload('res://scenes/level3.tscn'),
	preload('res://scenes/level4.tscn'),
]
var curr_level_index: int = 0
var level: Level

## Kill counts
var level_kill_count: int = 0: # Enemies killed in the current run of the level
	set(val):
		level_kill_count = val
		UILayer.set_score(level_kill_count, level.enemies.size())
var total_kill_count: int = 0 # Enemies killed in previous levels
var max_kill_count: int = 0 # Potential of enemies killed in previous levels

## Upgrades
var gun_unlocked: bool = false
var extra_jumps: int = 0

signal level_started


func _ready():
	game_world = get_tree().root.get_node('GameWorld')
	boulder = game_world.get_node('Boulder')
	camera = game_world.get_node('Camera2D')


func load_level(i: int):
	var level_holder: Node2D = game_world.get_node('Level')
	
	for child in level_holder.get_children():
		level_holder.remove_child(child)
	
	# Reset kills (in case player restarts from the end)
	if i == 0:
		total_kill_count = 0
		max_kill_count = 0
	
	curr_level_index = i
	level = levels[i].instantiate()
	level_holder.add_child(level)
	start_level()


func load_next_level():
	finish_level()
	
	if curr_level_index >= levels.size() - 1:
		if total_kill_count == max_kill_count:
			# TODO: Play secret cutscene (await)
			# await UILayer.play_video(load("path"))
			pass
		else:
			# TODO: Play loser cutscene (await)
			# await UILayer.play_video(load("path"))
			# TODO: or if you wanna show a popup or something instead
			# UILayer.show_the_thing()
			# return
			pass
		UILayer.show_credits()
		return
	
	load_level(curr_level_index + 1)


func restart_level():
	UILayer.show_death_screen(false)
	UILayer.show_level_end_screen(false)
	boulder.revive()
	load_level(curr_level_index)
	start_level()


func start_level():
	level_kill_count = 0
	
	boulder.process_mode = Node.PROCESS_MODE_DISABLED
	boulder.stop_movement()
	camera.set_follow_target(boulder)
	
	boulder.enable_gun(gun_unlocked)
	boulder.extra_jumps = extra_jumps
	
	boulder.process_mode = Node.PROCESS_MODE_INHERIT
	boulder.position = level.spawn_point.position
	boulder.show()
	boulder.disable_input(false)
	
	level_started.emit()


func finish_level():
	total_kill_count += level_kill_count
	max_kill_count += level.enemies.size()


func shake_camera(strength: float):
	camera.shake(strength)
