class_name Level
extends Node2D

@onready var spawn_point: Marker2D = $SpawnPoint
var obstacles: Array = [] # Save obstacles here
var enemies: Array[Enemy] = [] # Save enemies here, hide them when they die


func _ready():
	obstacles = $Obstacles.get_children()
	for child in $Enemies.get_children():
		if child is not Enemy: continue
		enemies.append(child)


func reset():
	for obstacle in obstacles:
		# TODO: Reset obstacle to initial state
		pass
	
	for enemy in enemies:
		enemy.respawn()


func get_kill_count() -> int:
	var count: int = 0
	for enemy in enemies:
		if enemy.dead: count += 1
	return count
