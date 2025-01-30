class_name Level
extends Node2D

@onready var spawn_point: Marker2D = $SpawnPoint

var enemies: Array[Enemy] = [] # Save enemies here, hide them when they die
var timer: Timer
@export var level_time: float = 999
@export var music: AudioStream

@export var unlock_gun: bool = false
@export var unlock_double_jump: bool = false


func _ready():
	# Save all enemies
	for child in $Enemies.get_children():
		if child is not Enemy: continue
		enemies.append(child)
	
	# Unlock power ups (Will stay unlocked for all future levels)
	if unlock_gun:
		GameState.gun_unlocked = true
	if unlock_double_jump:
		GameState.extra_jumps = 1
	
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start(level_time)
	SoundPlayer.play_music(music)


func _physics_process(_delta):
	if !timer.is_stopped():
		UILayer.update_timer(timer.time_left)


func _on_timer_timeout():
	GameState.boulder.die()
