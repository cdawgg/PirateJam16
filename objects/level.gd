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
		if obstacle is Shootable:
			obstacle.reset()
	
	for enemy in enemies:
		enemy.respawn()
